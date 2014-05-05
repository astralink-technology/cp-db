-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_entity_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_entity_relationship(
        pEntityRelationshipId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Authentication ID is needed if not return
    IF pEntityRelationshipId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from entity_relationship where 
        entity_relationship_id = pEntityRelationshipId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
