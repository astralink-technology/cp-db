-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_device_relationship(
        pDeviceRelationshipId varchar(32)
);
-- Start function
CREATE FUNCTION delete_device_relationship(
        pDeviceRelationshipId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Phone ID is needed if not return
    IF pDeviceRelationshipId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from device_relationship where 
        device_relationship_id = pDeviceRelationshipId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;