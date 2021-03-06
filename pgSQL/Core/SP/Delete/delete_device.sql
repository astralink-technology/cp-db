-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_device' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_device(
        pDeviceId varchar(32)
)
RETURNS BOOLEAN AS
$BODY$
BEGIN
-- Phone ID is needed if not return
    IF pDeviceId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from device d where (
	      d.device_id = pDeviceId
	);
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
