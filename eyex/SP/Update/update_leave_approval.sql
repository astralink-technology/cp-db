-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_leave_approval' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_leave_approval(
    pLeaveApprovalId varchar(32)
  , pType CHAR(1)
  , pNotes TEXT
)
  RETURNS BOOL AS
  $BODY$
DECLARE
    oType CHAR(1);
    oNotes TEXT;

    nType CHAR(1);
    nNotes TEXT;
BEGIN
    -- Rule ID is needed if not return
    IF pLeaveApprovalId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            l.type
            , l.notes
        INTO STRICT
          oType
          , oNotes
        FROM leave_approval l WHERE
            l.leave_approval_id = pLeaveApprovalId;

        -- Start the updating process
        IF pType IS NULL THEN
          nType := oType;
        ELSEIF pType = '' THEN
            -- defaulted null
          nType := NULL;
        ELSE
          nType := pType;
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
            leave_approval
        SET
            type = nType
            , notes = nNotes
        WHERE
            leave_approval_id = pLeaveApprovalId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;