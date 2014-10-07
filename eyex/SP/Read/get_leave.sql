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
    , pName varchar(64)
    , pType char(1)
    , pDateStart timestamp without time zone
    , pDateEnd timestamp without time zone
    , pOwnerId varchar(32)
    , pPageSize integer
    , pSkipSize integer
)
RETURNS TABLE(
    leave_id varchar(32)
    , name varchar(64)
    , type char(1)
    , date_start timestamp without time zone
    , date_end timestamp without time zone
    , create_date timestamp without time zone
    , last_update timestamp without time zone
    , owner_id varchar(32)
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
        , l.name
        , l.type
        , l.date_start
        , l.date_end
        , l.create_date
        , l.last_update
        , l.owner_id
      FROM leave l  WHERE (
       ((pLeaveId IS NULL) OR (l.leave_id = pLeaveId)) AND
       ((pName IS NULL) OR (l.name = pName)) AND
       ((pType IS NULL) OR (l.type = pType)) AND
       ((pDateStart IS NULL) OR (l.date_start = pDateStart)) AND
       ((pDateEnd IS NULL) OR (l.date_end = pDateEnd)) AND
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