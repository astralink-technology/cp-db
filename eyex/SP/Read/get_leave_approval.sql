-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_leave_approval' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_leave_approval(
    pLeaveApprovalId varchar(32)
  , pType CHAR(1)
  , pOwnerId varchar(32)
  , pLeaveId varchar(32)
  , pPageSize integer
  , pSkipSize integer
)
  RETURNS TABLE(
  leave_approval_id varchar(32),
  type CHAR(1),
  create_date timestamp without time zone,
  notes TEXT,
  owner_id varchar(32),
  leave_id varchar(32),
  totalRows integer
  )
AS
  $BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM leave_approval;

    -- create a temp table to get the data
    CREATE TEMP TABLE leave_approval_init AS
      SELECT
        la.leave_approval_id
        , la.type
        , la.create_date
        , la.notes
        , la.owner_id
        , la.leave_id
          FROM leave_approval la WHERE (
           ((pLeaveApprovalId IS NULL) OR (la.leave_approval_id = pLeaveApprovalId)) AND
           ((pType IS NULL) OR (la.type = pType)) AND
           ((pOwnerId IS NULL) OR (la.owner_id = pOwnerId)) AND
           ((pLeaveId IS NULL) OR (la.leave_id = pLeaveId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM leave_approval_init;
END;
$BODY$
LANGUAGE plpgsql;