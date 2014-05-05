-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_message' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
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
