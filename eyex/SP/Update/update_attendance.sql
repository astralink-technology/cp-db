-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_attendance' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_attendance(
    pAttendanceId varchar(32)
    , pName varchar(64)
    , pType char(1)
    , pTimeIn timestamp without time zone
    , pTimeOut timestamp without time zone
    , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oName varchar(64);
    oType char(1);
    oTimeIn timestamp without time zone;
    oTimeOut timestamp without time zone;
    oLastUpdate timestamp without time zone;

    nName varchar(64);
    nType char(1);
    nTimeIn timestamp without time zone;
    nTimeOut timestamp without time zone;
    nLastUpdate timestamp without time zone;
BEGIN
    -- Attendance ID is needed if not return
    IF pAttendanceId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
          a.name
          , a.type
          , a.time_in
          , a.time_out
          , a.last_update
        INTO STRICT
          oName
          , oType
          , oTimeIn
          , oTimeOut
          , oLastUpdate
        FROM attendance a WHERE
            a.attendance_id = pAttendanceId;

        -- Start the updating process
        IF pName IS NULL THEN 
            nName := oName;
        ELSEIF pName = '' THEN   
            -- defaulted null
            nName := NULL;
        ELSE
            nName := pName;
        END IF;

        IF pType IS NULL THEN
            nType := oType;
        ELSEIF pType = '' THEN
            -- defaulted null
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pTimeIn IS NULL THEN
            nTimeIn := oTimeIn;
        ELSEIF pTimeIn = '' THEN
            -- defaulted null
            nTimeIn := NULL;
        ELSE
            nTimeIn := pTimeIn;
        END IF;
        
        IF pTimeOut IS NULL THEN
            nTimeOut := oTimeOut;
        ELSEIF pTimeOut = '' THEN
            -- defaulted null
            nTimeOut := NULL;
        ELSE
            nTimeOut := pTimeOut;
        END IF;

        IF pLastUpdate IS NULL THEN
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            attendance
        SET
            name = nName
            , type = nType
            , time_in = nTimeIn
            , time_out = nTimeOut
            , last_update = nLastUpdate
        WHERE
            attendance_id = pAttendanceId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;