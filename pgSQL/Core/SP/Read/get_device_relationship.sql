-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_device_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_device_relationship(
	pDeviceRelationshipId varchar(32)
	, pDeviceId varchar(32)
	, pOwnerId varchar(32)
	, pAppName varchar(64)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	device_relationship_id varchar(32)
	, device_id varchar(32)
	, owner_id varchar(32)
	, app_name varchar(64)
	, last_update timestamp without time zone
	, create_date timestamp without time zone
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
    FROM device_relationship dr WHERE (
      ((pDeviceRelationshipId IS NULL) OR (dr.device_relationship_id = pDeviceRelationshipId)) AND
      ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId)) AND
      ((pOwnerId IS NULL) OR (dr.owner_id = pOwnerId))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE device_relationship_init AS
      SELECT
        dr.device_relationship_id
        , dr.device_id
        , dr.owner_id
	, dr.app_name
        , dr.last_update
        , dr.create_date
      FROM device_relationship dr WHERE (
        ((pDeviceRelationshipId IS NULL) OR (dr.device_relationship_id = pDeviceRelationshipId)) AND
        ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId)) AND
        ((pOwnerId IS NULL) OR (dr.owner_id = pOwnerId))
        )
      ORDER BY dr.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM device_relationship_init;

END;
$BODY$
LANGUAGE plpgsql;
