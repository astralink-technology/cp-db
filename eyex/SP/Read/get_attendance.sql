-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_attendance' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_attendance(
    pAttendanceId varchar(32)
    , pName varchar(64)
    , pDateTimeFilterStart timestamp without time zone
    , pDateTimeFilterEnd timestamp without time zone
    , pTimeInDate date
    , pTimeOutDate date
    , pType char(1)
    , pOwnerId varchar(32)
    , pPageSize integer
    , pSkipSize integer
)
RETURNS TABLE(
    attendance_id varchar(32)
    , name varchar(64)
    , type char(1)
    , time_in timestamp without time zone
    , time_out timestamp without time zone
    , create_date timestamp without time zone
    , last_update timestamp without time zone
    , owner_id varchar(32)
    , totalRows integer
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
    FROM attendance;

    -- create a temp table to get the data
    CREATE TEMP TABLE attendance_init AS
      SELECT
        a.attendance_id
        , a.name
        , a.type
        , a.time_in
        , a.time_out
        , a.create_date
        , a.last_update
        , a.owner_id
          FROM attendance a WHERE (
           ((pAttendanceId IS NULL) OR (a.attendance_id = pAttendanceId)) AND
           ((pName IS NULL) OR (a.name = pName)) AND
           ((pDateTimeFilterStart IS NULL OR pDateTimeFilterEnd IS NULL) OR (a.create_date BETWEEN pDateTimeFilterStart AND pDateTimeFilterEnd)) AND
           ((pTimeInDate IS NULL) OR (a.time_in BETWEEN (pTimeInDate  || 'T' || '00:00')::timestamp AND ((pTimeInDate || 'T' || '23:59')::timestamp)) AND
           ((pTimeOutDate IS NULL) OR (a.time_out BETWEEN (pTimeOutDate  || 'T' || '00:00')::timestamp AND ((pTimeOutDate || 'T' || '23:59')::timestamp)) AND
           ((pType IS NULL) OR (a.type = pType)) AND
           ((pOwnerId IS NULL) OR (a.owner_id = pOwnerId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM attendance_init;
END;
$BODY$
LANGUAGE plpgsql;