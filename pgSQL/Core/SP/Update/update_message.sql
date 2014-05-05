-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_message' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_message(
    pMessageId varchar(32)
    , pMessage text
    , pType char(1)
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
    , pTriggerEvent char(2)
    , pSubject varchar(128)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    nMessage text;
    nType char(1);
    nLastUpdate timestamp without time zone;
    nOwnerId varchar(32);
    nTriggerEvent char(2);
    nSubject varchar(128);

    oMessage text;
    oType char(1);
    oLastUpdate timestamp without time zone;
    oOwnerId varchar(32);
    oTriggerEvent char(2);
    oSubject varchar(128);
BEGIN
    -- Message ID is needed if not return
    IF pMessageId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            e.message
            , e.type
            , e.last_update
            , e.owner_id
            , e.trigger_event
            , e.subject
        INTO STRICT
            oMessage
            , oType
            , oLastUpdate
            , oOwnerId
            , oTriggerEvent
            , oSubject
        FROM message e WHERE
            e.message_id = pMessageId;

        -- Start the updating process
        IF pMessage IS NULL THEN 
            nMessage := oMessage;
        ELSEIF pMessage = '' THEN  
            nMessage := NULL;
        ELSE
            nMessage := pMessage;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pType = '' THEN  
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        IF pOwnerId IS NULL THEN 
            nOwnerId := oOwnerId;
        ELSEIF pOwnerId = '' THEN  
            nOwnerId := NULL;
        ELSE
            nOwnerId := pOwnerId;
        END IF;

        IF pTriggerEvent IS NULL THEN 
            nTriggerEvent := oTriggerEvent;
        ELSEIF pTriggerEvent = '' THEN  
            nTriggerEvent := NULL;
        ELSE
            nTriggerEvent := pTriggerEvent;
        END IF;
        
        IF pSubject IS NULL THEN
            nSubject := oSubject;
        ELSEIF pSubject = '' THEN
            nSubject := NULL;
        ELSE
            nSubject := pSubject;
        END IF;

        -- start the update
        UPDATE 
            message
        SET 
            message = nMessage
            , type = nType
            , last_update = nLastUpdate
            , owner_id = nOwnerId
            , trigger_event = nTriggerEvent
            , subject = nSubject
        WHERE
            message_id = pMessageId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
