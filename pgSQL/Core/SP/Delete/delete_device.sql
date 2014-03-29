-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_device(
        pDeviceId varchar(32)
);
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
