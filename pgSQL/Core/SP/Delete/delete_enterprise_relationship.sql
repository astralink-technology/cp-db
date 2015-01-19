-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_enterprise_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_enterprise_relationship(
        pEnterpriseRelationshipId varchar(32)
)
RETURNS BOOLEAN AS
$BODY$
BEGIN
-- Enterprise Relationship ID is needed if not return
    IF pEnterpriseRelationshipId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from enterprise_relationship where
          enterprise_relationship_id = pEnterpriseRelationshipId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;