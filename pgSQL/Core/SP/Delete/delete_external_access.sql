-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_external_access' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_external_access(
        pExternalAccessId varchar(32)
)
RETURNS BOOLEAN AS
$BODY$
BEGIN
-- Enterprise Relationship ID is needed if not return
    IF pExternalAccessId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from external_access where
          external_access_id = pExternalAccessId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;