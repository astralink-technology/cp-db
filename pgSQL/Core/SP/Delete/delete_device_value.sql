-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_device_value(
        pDeviceValueId varchar(32),
        pDeviceId varchar(32)
);
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
