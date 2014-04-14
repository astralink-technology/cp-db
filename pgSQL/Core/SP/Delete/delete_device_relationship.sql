-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_device_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
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