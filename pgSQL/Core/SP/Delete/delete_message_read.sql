-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_message_read' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_message_read(
        pMessageReadId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Message Read ID is needed if not return
    IF pMessageReadId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE FROM message_read WHERE
          message_read_id = pMessageReadId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
