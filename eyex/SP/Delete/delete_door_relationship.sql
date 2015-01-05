-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_door_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_door_relationship(
        pDoorRelationshipId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Door Relationship ID is needed if not return
    IF pDoorRelationshipId  IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from door_relationship where
        door_relationship_id = pDoorRelationshipId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;