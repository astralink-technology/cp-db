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
  , pType CHAR(1)
  , pLeaveStart timestamp without time zone
  , pLeaveEnd timestamp without time zone
  , pLeaveCount DECIMAL
  , pNotes TEXT  
)
  RETURNS BOOL AS
  $BODY$
DECLARE
    oType CHAR(1);
    oLeaveStart timestamp without time zone;   
    oLeaveEnd timestamp without time zone;
    oLeaveCount DECIMAL;
    oNotes TEXT;

    nType CHAR(1);
    nLeaveStart timestamp without time zone;
    nLeaveEnd timestamp without time zone;
    nLeaveCount DECIMAL;
    nNotes TEXT;
BEGIN
    -- Rule ID is needed if not return
    IF pLeaveId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            l.type
            , l.leave_start
            , l.leave_end
            , l.leave_count
            , l.notes
        INTO STRICT
          oType
          , oLeaveStart
          , oLeaveEnd
          , oLeaveCount
          , oNotes
        FROM leave l WHERE
            l.leave_id = pLeaveId;

        -- Start the updating process
        IF pType IS NULL THEN
          nType := oType;
        ELSEIF pType = '' THEN
            -- defaulted null
          nType := NULL;
        ELSE
          nType := pType;
        END IF;

        IF pLeaveStart IS NULL THEN
          nLeaveStart := oLeaveStart;
        ELSE
          nLeaveStart := pLeaveStart;
        END IF;

        IF pLeaveEnd IS NULL THEN
          nLeaveEnd := oLeaveEnd;
        ELSE
          nLeaveEnd := pLeaveEnd;
        END IF;

        IF pLeaveCount IS NULL THEN
          nLeaveCount := oLeaveCount;
        ELSEIF pLeaveCount = '' THEN
        -- defaulted null
          nLeaveCount := NULL;
        ELSE
          nLeaveCount := pLeaveCount;
        END IF;

        IF pNotes IS NULL THEN
          nNotes := oNotes;
        ELSEIF pNotes = '' THEN
        -- defaulted null
          nNotes := NULL;
        ELSE
          nNotes := pNotes;
        END IF;


        -- start the update
        UPDATE
            leave
        SET
            type = nType
            , leave_start = nLeaveStart
            , leave_end = nLeaveEnd
            , leave_count = nLeaveCount
            , notes = nNotes
        WHERE
            leave_id = pLeaveId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;