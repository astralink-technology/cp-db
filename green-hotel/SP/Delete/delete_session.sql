-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_session' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_session(
        pSessionId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Session ID is needed if not return
    IF pSessionId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- delete the session
        DELETE FROM session WHERE
        session_id = pSessionId;

        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;