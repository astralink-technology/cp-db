-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_leave' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_leave(
    pLeaveId varchar(32)
    , pName varchar(64)
    , pType char(1)
    , pDateStart timestamp without time zone
    , pDateEnd timestamp without time zone
    , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oName varchar(64);
    oType char(1);
    oDateStart timestamp without time zone;
    oDateEnd timestamp without time zone;
    oLastUpdate timestamp without time zone;

    nName varchar(64);
    nType char(1);
    nDateStart timestamp without time zone;
    nDateEnd timestamp without time zone;
    nLastUpdate timestamp without time zone;
BEGIN
    -- Attendance ID is needed if not return
    IF pLeaveId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
          l.name
          , l.type
          , l.date_start
          , l.date_end
          , l.last_update
        INTO STRICT
          oName
          , oType
          , oDateStart
          , oDateEnd
          , oLastUpdate
        FROM leave l WHERE
            l.leave_id = pLeaveId;

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

        IF pDateStart IS NULL THEN
            nDateStart := oDateStart;
        ELSEIF pDateStart = '' THEN
            -- defaulted null
            nDateStart := NULL;
        ELSE
            nDateStart := pDateStart;
        END IF;
        
        IF pDateEnd IS NULL THEN
            nDateEnd := oDateEnd;
        ELSEIF pDateEnd = '' THEN
            -- defaulted null
            nDateEnd := NULL;
        ELSE
            nDateEnd := pDateEnd;
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
            , date_start = nDateStart
            , date_end = nDateEnd
            , last_update = nLastUpdate
        WHERE
            leave_id = pLeaveId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;