-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS update_device_session(
	pDeviceId varchar(32)
	, pConnectedDeviceId varchar(32) 
	, pStatus char(1) 
);
-- Start function
CREATE FUNCTION update_device_session(
	pDeviceId varchar(32)
	, pConnectedDeviceId varchar(32) 
	, pStatus char(1) 
)
RETURNS BOOL AS
$BODY$
DECLARE
     nDeviceId varchar(32); 
     nConnectedDeviceId varchar(32);
     nStatus char(1);

     oDeviceId varchar(32);
     oConnectedDeviceId varchar(32);
     oStatus char(1);
BEGIN
    -- ID is needed if not return
    IF pDeviceId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            ds.device_id 
            , ds.connected_device_id
            , ds.status
        INTO STRICT
            oDeviceId 
            , oConnectedDeviceId
            , oStatus
        FROM device_session ds WHERE
            ds.device_id = pDeviceId;

        -- Start the updating process
        IF pDeviceId IS NULL THEN 
            nDeviceId := oDeviceId;
        ELSEIF pFirstName = '' THEN  
            nDeviceId := NULL;
        ELSE
            nDeviceId := pDeviceId;
        END IF;

        IF pConnectedDeviceId IS NULL THEN 
            nConnectedDeviceId := oConnectedDeviceId;
        ELSEIF pConnectedDeviceId = '' THEN  
            nConnectedDeviceId := NULL;
        ELSE
            nConnectedDeviceId := pConnectedDeviceId;
        END IF;

        IF pStatus IS NULL THEN
            nStatus := oStatus;
        ELSEIF pStatus = '' THEN
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;


        -- start the update
        UPDATE 
            device_session
        SET 
            device_id = nDeviceId
            , connected_device_id = nConnectedDeviceId
            , status = nStatus
        WHERE
            device_id = pDeviceId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
