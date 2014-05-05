-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_device_session' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_device_session(
	pDeviceId varchar(32)
	, pConnectedDeviceId varchar(32)
	, pStatus char(1)
	, pCreateDate timestamp without time zone
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO device_session(
      device_id
      , connected_device_id
      , status
      , create_date
    ) VALUES(
      pDeviceId
      , pConnectedDeviceId
      , pStatus
      , pCreateDate
    );
    RETURN pDeviceId;
END;
$BODY$
LANGUAGE plpgsql;
