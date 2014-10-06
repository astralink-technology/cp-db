-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_attendance' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_attendance(
        pAttendanceId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Attendance ID is needed if not return
    IF pAttendanceId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from attendance where
        attendance_id = pAttendanceId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;