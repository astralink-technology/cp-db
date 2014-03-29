-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS update_log(
    pLogId varchar(32) 
    , pMessage text
    , pTitle varchar(32)
    , pType varchar(32)
    , pLogUrl text 
    , pStatus char(1)
    , pOwnerId varchar(32)
);
-- Start function
CREATE FUNCTION update_log(
    pLogId varchar(32) 
    , pMessage text
    , pTitle varchar(32)
    , pType char(1)
    , pLogUrl text 
    , pStatus char(1)
    , pOwnerId varchar(32)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oMessage text;
    oTitle varchar(32);
    oType char(1);
    oLogUrl text;
    oStatus char(1);
    oOwnerId varchar(32);

    nMessage text;
    nTitle varchar(32);
    nType char(1);
    nLogUrl text ;
    nStatus char(1);
    nOwnerId varchar(32);
BEGIN
    -- ID is needed if not return
    IF pLogId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            l.message 
            , l.title
            , l.type 
            , l.log_url 
            , l.status 
            , l.owner_id
        INTO STRICT
            oMessage
            , oTitle
            , oType
            , oLogUrl
            , oStatus
            , oOwnerId
        FROM log l WHERE 
            l.log_id = pLogId;

        -- Start the updating process
        IF pMessage IS NULL THEN 
            nMessage := oMessage;
        ELSEIF pFirstMessage = '' THEN  
            nMessage := NULL;
        ELSE
            nMessage := pMessage;
        END IF;

        IF pTitle IS NULL THEN 
            nTitle := oTitle;
        ELSEIF pDevice2Id = '' THEN  
            nTitle := NULL;
        ELSE
            nTitle := pTitle;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pType = '' THEN  
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pLogUrl IS NULL THEN 
            nLogUrl := oLogUrl;
        ELSEIF pLogUrl = '' THEN  
            nLogUrl := NULL;
        ELSE
            nLogUrl := pLogUrl;
        END IF;

        IF pStatus IS NULL THEN 
            nStatus := oStatus;
        ELSEIF pStatus = '' THEN  
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;

        IF pOwnerId IS NULL THEN 
            nOwnerId := oOwnerId;
        ELSEIF pOwnerId = '' THEN  
            nOwnerId := NULL;
        ELSE
            nOwnerId := pOwnerId;
        END IF;


        -- start the update
        UPDATE 
            log
        SET 
            message = nMessage
            , title = nTitle
            , type  = nType
            , log_url  = nLogUrl
            , status  = nStatus
            , owner_id = nOwnerId
        WHERE 
            log_id = pLogId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
