-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_phone(
        pPhoneId varchar(32),
        pDeviceId varchar(32)
);
-- Start function
CREATE FUNCTION delete_phone(
        pPhoneId varchar(32),
        pDeviceId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Phone ID is needed if not return
    IF pPhoneId IS NULL AND pDeviceId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from phone WHERE (
		    phone_id = pPhoneId OR
		    device_id = pDeviceId
	);
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

