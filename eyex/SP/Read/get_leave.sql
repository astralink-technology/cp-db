-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_leave' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_leave(
    pLeaveId varchar(32)
  , pType CHAR(1)
  , pOwnerId varchar(32)
  , pPageSize integer
  , pSkipSize integer
)
  RETURNS TABLE(
  leave_id varchar(32),
  type CHAR(1),
  create_date timestamp without time zone,
  leave_start timestamp without time zone,
  leave_end timestamp without time zone,
  leave_count DECIMAL,
  notes TEXT,
  owner_id varchar(32),
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
    FROM leave;

    -- create a temp table to get the data
    CREATE TEMP TABLE leave_init AS
      SELECT
        l.leave_id
        , l.type
        , l.create_date
        , l.leave_start
        , l.leave_end
        , l.leave_count
        , l.notes
        , l.owner_id
          FROM leave l WHERE (
           ((pLeaveId IS NULL) OR (l.leave_id = pLeaveId)) AND
           ((pType IS NULL) OR (l.type = pType)) AND
           ((pOwnerId IS NULL) OR (l.owner_id = pOwnerId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM leave_init;
END;
$BODY$
LANGUAGE plpgsql;