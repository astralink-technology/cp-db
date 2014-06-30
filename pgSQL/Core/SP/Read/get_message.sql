-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_message' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_message(
    pMessageId varchar(32)
    , pMessage text
    , pType char(1)
    , pOwnerId varchar(32)  
    , pTriggerEvent char(2)
    , pStatus char(1)
    , pPageSize integer
    , pSkipSize integer
)
RETURNS TABLE(
	message_id varchar(32) 
	, message text
	, type char(1)
	, create_date timestamp without time zone
	, last_update timestamp without time zone
	, owner_id varchar(32)
	, trigger_event char(2)
	, subject varchar(128)
	, status char(1)
	, total_rows integer
) AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM message m WHERE (
      ((pMessageId IS NULL) OR (m.message_id = pMessageId)) AND
      ((pMessage IS NULL) OR (m.message = pMessage)) AND
      ((pType IS NULL) OR (m.type = pType)) AND
      ((pOwnerId IS NULL) OR (m.owner_id = pOwnerId)) AND
      ((pStatus IS NULL) OR (m.status = pStatus)) AND
      ((pTriggerEvent IS NULL) OR (m.trigger_event = pTriggerEvent))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE message_init AS
      SELECT
        m.message_id
        , m.message
        , m.type
        , m.create_date
        , m.last_update
        , m.owner_id
        , m.trigger_event
        , m.subject
        , m.status
      FROM message m WHERE (
        ((pMessageId IS NULL) OR (m.message_id = pMessageId)) AND
        ((pMessage IS NULL) OR (m.message = pMessage)) AND
        ((pType IS NULL) OR (m.type = pType)) AND
        ((pOwnerId IS NULL) OR (m.owner_id = pOwnerId)) AND
        ((pStatus IS NULL) OR (m.status = pStatus)) AND
        ((pTriggerEvent IS NULL) OR (m.trigger_event = pTriggerEvent))
        )
      ORDER BY m.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM message_init;
END;
$BODY$
LANGUAGE plpgsql;