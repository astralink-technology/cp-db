-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_extension' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_extension(
        pExtensionId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Extension ID is needed if not return
    IF pExtensionId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from extension where
        extension_id = pExtensionId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;