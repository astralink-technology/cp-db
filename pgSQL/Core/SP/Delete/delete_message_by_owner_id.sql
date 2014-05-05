-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_message_by_owner_id' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_message_by_owner_id(
        pOwnerId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Device ID is needed if not return
    IF pOwnerId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from message where 
        owner_id = pOwnerId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
