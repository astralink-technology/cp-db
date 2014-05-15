-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_device_session' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_device_session(
	pDeviceId varchar(32)
	, pConnectedDeviceId varchar(32) 
	, pStatus char(1)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	device_id varchar(32) 
	, connected_device_id varchar(32) 
	, status char(1)
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
    FROM device_session ds WHERE (
      ((pDeviceId IS NULL) OR (ds.device_id = pDeviceId)) AND
      ((pConnectedDeviceId IS NULL) OR (ds.connected_device_id = pConnectedDeviceId)) AND
      ((pStatus IS NULL) OR (ds.status = pStatus))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE device_session_init AS
      SELECT
        ds.device_id
        , ds.connected_device_id
        , ds.status
        , ds.create_date
      FROM device_session ds WHERE (
        ((pDeviceId IS NULL) OR (ds.device_id = pDeviceId)) AND
        ((pConnectedDeviceId IS NULL) OR (ds.connected_device_id = pConnectedDeviceId)) AND
        ((pStatus IS NULL) OR (ds.status = pStatus))
        )
      ORDER BY ds.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM device_session_init;
END;
$BODY$
LANGUAGE plpgsql;
