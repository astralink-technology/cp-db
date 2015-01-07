-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_device_detail' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_device_detail(
        pDeviceId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Device ID is needed if not return
    IF pDeviceId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- delete from device
        DELETE FROM device WHERE
        device_id = pDeviceId;

        -- delete from device value
        DELETE FROM device_value WHERE
        device_id = pDeviceId;

        -- delete from device_relationship
        DELETE from device_relationship WHERE
        device_id = pDeviceId;

        -- delete from door relationship
        DELETE FROM door_relationship WHERE
        device_id = pDeviceId;

        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;