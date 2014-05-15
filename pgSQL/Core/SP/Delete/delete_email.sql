-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_email' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_email(
        pEmailId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Email ID is needed if not return
    IF pEmailId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from email where 
        email_id = pEmailId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;