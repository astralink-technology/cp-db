-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_message' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_message(
        pMessageId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Message ID is needed if not return
    IF pMessageId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from message where 
        message_id = pMessageId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
