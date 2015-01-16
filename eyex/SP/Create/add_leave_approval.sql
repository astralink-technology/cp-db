-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_leave_approval' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_leave_approval(
    pLeaveApprovalId varchar(32)
  , pType CHAR(1)
  , pCreateDate timestamp without time zone
  , pNotes TEXT
  , pOwnerId varchar(32)
  , pLeaveId varchar(32)
)
  RETURNS varchar(32) AS
  $BODY$
BEGIN
    INSERT INTO leave_approval (
        leave_approval_id
        , type
        , create_date
        , notes
        , owner_id
        , leave_id
    ) VALUES(
        pLeaveApprovalId
        , pType
        , pCreateDate
        , pNotes
        , pOwnerId
        , pLeaveId
    );
    RETURN pLeaveApprovalId;
END;
$BODY$
LANGUAGE plpgsql;