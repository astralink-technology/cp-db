-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_device_value' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_device_value(
        pDeviceValueId varchar(32),
        pDeviceId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
    IF pDeviceValueId IS NULL AND pDeviceId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from device_value WHERE (
        device_id = pDeviceId OR
        device_value_id = pDeviceValueId
	);
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
