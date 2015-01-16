-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_session_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_session_relationship(
        pSessionRelationshipId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Session Relationship ID is needed if not return
    IF pSessionRelationshipId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- delete the session relationship
        DELETE FROM session_relationship WHERE
        session_relationship_id = pSessionRelationshipId;

        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;