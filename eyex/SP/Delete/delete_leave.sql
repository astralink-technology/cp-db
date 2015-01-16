-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_leave' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_leave(
  pLeaveId varchar(32)
)
  RETURNS BOOLEAN AS
  $BODY$
BEGIN
-- Leave ID is needed if not return
    IF pLeaveId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from leave where
        leave_id = pLeaveId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;