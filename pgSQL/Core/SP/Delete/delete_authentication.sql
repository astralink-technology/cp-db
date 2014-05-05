-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_authentication' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_authentication(
        pAuthenticationId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Authentication ID is needed if not return
    IF pAuthenticationId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from authentication where 
        authentication_id = pAuthenticationId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;