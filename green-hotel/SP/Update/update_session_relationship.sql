-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_session_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_session_relationship(
    pSessionRelationshipId VARCHAR(32)
    , pSessionId VARCHAR(32)
    , pOwnerId VARCHAR(32)
    , pType VARCHAR(4)
    , pStatus CHAR(4)
)
RETURNS BOOL AS
$BODY$
DECLARE
      oSessionId varchar(32);
      oOwnerId varchar(32);
      oType varchar(4);
      oStatus char(1);

      nSessionId varchar(32);
      nOwnerId varchar(32);
      nType varchar(4);
      nStatus char(1);
BEGIN
    -- Session Relationship ID is needed if not return
    IF pSessionRelationshipId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            sr.owner_id
            , sr.session_id
            , sr.type
            , sr.status
        INTO  STRICT
            oOwnerId
            , oSessionId
            , oType
            , oStatus
        FROM session_relationship sr WHERE
            sr.session_relationship_id = pSessionRelationshipId;

        -- Start the updating process
        IF pOwnerId IS NULL THEN
            nOwnerId := oOwnerId;
        ELSEIF pOwnerId = '' THEN
            -- defaulted null
            nOwnerId := NULL;
        ELSE
            nOwnerId := pOwnerId;
        END IF;

        IF pSessionId IS NULL THEN
            nSessionId := oSessionId;
        ELSEIF pSessionId = '' THEN
            -- defaulted null
            nSessionId := NULL;
        ELSE
            nSessionId := pSessionId;
        END IF;

        IF pType IS NULL THEN
            nType := oType;
        ELSEIF pType = '' THEN
            -- defaulted null
            nType := NULL;
        ELSE
            nType := pType;
        END IF;
        
        IF pStatus IS NULL THEN
            nStatus := oStatus;
        ELSEIF pStatus = '' THEN
            -- defaulted null
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;

        -- start the update
        UPDATE
            session_relationship
        SET
            owner_id = nOwnerId
            , session_id = nSessionId
            , type = nType
            , status = nStatus
        WHERE
            session_relationship_id = pSessionRelationshipId;

        RETURN TRUE;

    END IF;
END;
$BODY$
LANGUAGE plpgsql;