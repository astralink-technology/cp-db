-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_leave_approval' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_leave_approval(
  pLeaveApprovalId varchar(32)
)
  RETURNS BOOLEAN AS
  $BODY$
BEGIN
-- LeaveApproval ID is needed if not return
    IF pLeaveApprovalId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from leave_approval where
        leave_approval_id = pLeaveApprovalId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;