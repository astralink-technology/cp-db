-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_device' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_device(
	pDeviceId varchar(32)
	, pName varchar(32) 
	, pCode varchar(32)
	, pStatus char(1)
	, pType varchar(4)
	, pType2 varchar(4)
	, pOwnerId varchar(32)
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
	, create_date timestamp without time zone
	, last_update timestamp without time zone
	, owner_id varchar(32)
	, deployment_date date
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
    FROM device d WHERE (
      ((pOwnerId IS NULL) OR (d.owner_id = pOwnerId)) AND
      ((pName IS NULL) OR (d.name = pName)) AND
      ((pCode IS NULL) OR (d.code = pCode))AND
      ((pStatus IS NULL) OR (d.status = pStatus))AND
      ((pType IS NULL) OR (d.type = pType))AND
      ((pType2 IS NULL) OR (d.type2 = pType2))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE device_init AS
      SELECT
        d.device_id
        , d.name
        , d.code
        , d.status
        , d.type
        , d.type2
        , d.description
        , d.create_date
        , d.last_update
        , d.owner_id
        , d.deployment_date
      FROM device d WHERE (
        ((pDeviceId IS NULL) OR (d.device_id = pDeviceId)) AND
        ((pOwnerId IS NULL) OR (d.owner_id = pOwnerId)) AND
        ((pName IS NULL) OR (d.name = pName)) AND
        ((pCode IS NULL) OR (d.code = pCode))AND
        ((pStatus IS NULL) OR (d.status = pStatus))AND
        ((pType IS NULL) OR (d.type = pType))AND
        ((pType2 IS NULL) OR (d.type2 = pType2))
      )
      ORDER BY d.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
      SELECT
        *
        , totalRows
      FROM device_init;
END;
$BODY$
LANGUAGE plpgsql;
