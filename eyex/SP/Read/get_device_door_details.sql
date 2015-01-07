-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_device_door_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_device_door_details(
	pDeviceId varchar(32)
	, pOwnerId varchar(32)
	, pType varchar(4)
	, pType2 varchar(4)
	, pDoorName varchar(64)
	, pDoorNode integer
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	device_id varchar(32)
	, name varchar(32)
	, code varchar(32)
	, status char(1)
	, type varchar(4)
	, type2 varchar(4)
	, description text
	, deployment_date date
	, create_date timestamp without time zone
	, last_update timestamp without time zone
	, owner_id varchar(32)
	, door_id varchar(32)
  , door_name varchar(64)
  , door_last_update timestamp without time zone
	, total_rows integer
) AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM device_relationship ddr LEFT JOIN device d ON d.device_id = ddr.device_id
    LEFT JOIN door_relationship dr ON d.device_id = dr.device_id
    LEFT JOIN door dd ON dd.door_id = dr.door_id WHERE
    (
      ((pDeviceId IS NULL) OR (d.device_id = pDeviceId)) AND
      ((pType IS NULL) OR (d.type = pType))AND
      ((pType2 IS NULL) OR (d.type2 = pType2)) AND
      ((pDoorName IS NULL) OR (dd.door_name = pDoorName)) AND
      ((pOwnerId IS NULL) OR (ddr.owner_id = pOwnerId)) AND
      ((pDoorNode IS NULL) OR (dd.door_node = pDoorNode))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE device_door_detail_init AS
      SELECT
        d.device_id
        , d.name
        , d.code
        , d.status
        , d.type
        , d.type2
        , d.description
        , d.deployment_date
        , d.create_date
        , d.last_update
        , ddr.owner_id
        , dd.door_id
        , dd.door_name
        , dd.last_update AS door_last_update
    FROM device_relationship ddr LEFT JOIN device d ON d.device_id = ddr.device_id
    LEFT JOIN door_relationship dr ON d.device_id = dr.device_id
    LEFT JOIN door dd ON dd.door_id = dr.door_id WHERE
    (
      ((pDeviceId IS NULL) OR (d.device_id = pDeviceId)) AND
      ((pType IS NULL) OR (d.type = pType))AND
      ((pType2 IS NULL) OR (d.type2 = pType2)) AND
      ((pDoorName IS NULL) OR (dd.door_name = pDoorName)) AND
      ((pOwnerId IS NULL) OR (ddr.owner_id = pOwnerId)) AND
      ((pDoorNode IS NULL) OR (dd.door_node = pDoorNode))
    )
    ORDER BY d.create_date
    LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM device_door_detail_init;
END;
$BODY$
LANGUAGE plpgsql;
