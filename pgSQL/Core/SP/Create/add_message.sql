-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_message(
    pMessageId varchar(32)
    , pMessage text
    , pType char(1)
    , pCreateDate timestamp without time zone
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
    , pTriggerEvent char(2)
);
-- Start function
CREATE FUNCTION add_message(
    pMessageId varchar(32)
    , pMessage text
    , pType char(1)
    , pCreateDate timestamp without time zone
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
    , pTriggerEvent char(2)
    , pSubject varchar(128)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO message (
	message_id 
	, message
	, type
	, create_date
	, last_update
	, owner_id
	, trigger_event
	, subject
    ) VALUES(
        pMessageId
        , pMessage
        , pType
        , pCreateDate
        , pLastUpdate
        , pOwnerId 
        , pTriggerEvent
        , pSubject
    );
    RETURN pMessageId;
END;
$BODY$
LANGUAGE plpgsql;
