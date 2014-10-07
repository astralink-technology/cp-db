-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_attendance' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start functions
CREATE FUNCTION add_attendance(
    pAttendanceId varchar(32)
    , pName varchar(64)
    , pType char(1)
    , pTimeIn timestamp without time zone
    , pTimeOut timestamp without time zone
    , pCreateDate timestamp without time zone
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO attendance (
      attendance_id
      , name
      , type
      , time_in
      , time_out
      , create_date
      , last_update
      , owner_id
    ) VALUES(
      pAttendanceId
      , pName
      , pType
      , pTimeIn
      , pTimeOut
      , pCreateDate
      , pLastUpdate
      , pOwnerId
    );
    RETURN pAttendanceId;
END;
$BODY$
LANGUAGE plpgsql;