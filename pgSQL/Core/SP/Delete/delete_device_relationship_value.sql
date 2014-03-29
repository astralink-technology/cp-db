-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_device_relationship_value(
        pDeviceRelationshipValueId varchar(32),
        pDeviceRelationshipId varchar(32)
);
-- Start function
CREATE FUNCTION delete_device_relationship_value(
        pDeviceRelationshipValueId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
    IF pDeviceRelationshipValueId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from device_relationship_value WHERE (
        device_relationship_value_id = pDeviceRelationshipValueId
	);
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
