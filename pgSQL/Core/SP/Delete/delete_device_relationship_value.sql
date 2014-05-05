-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_device_relationship_value' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
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
