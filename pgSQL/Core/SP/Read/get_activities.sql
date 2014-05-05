-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_activity' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_activity(
	pLogId varchar(32)
	, pMessageId varchar(32)
	, pDeviceRelationshipId varchar(32)
	, pOwnerId varchar(32)
	, pDeviceId varchar(32)
	, pLogTitle varchar(32)
	, pLogType char(1)
	, pLogStatus char(1)
	, pMessageType text[]
	, pMessageTriggerEvent char(32)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
  activity_id varchar(32)
  , log_message text
  , log_title varchar(32)
  , log_type char(1)
  , log_url text
  , log_status char(1)
  , log_create_date timestamp without time zone
  , owner_id varchar(32)
  , device_id varchar(32)
  , device_relationship_id varchar(32)
  , message text
  , message_type char(1)
  , message_create_date timestamp without time zone
  , message_trigger_event char(2)
  , total_rows integer
) AS
$BODY$
DECLARE
    totalRows integer;
BEGIN

    CREATE TEMP TABLE log_activities AS
      SELECT
      l.log_id as activity_id
      , l.message as log_message
      , l.title as log_title
      , l.type as log_type
      , l.log_url
      , l.status as log_status
      , l.create_date as log_create_date
      , dr.owner_id
      , dr.device_id
      , dr.device_relationship_id
      FROM log l LEFT OUTER JOIN
      device_relationship dr ON dr.device_id = l.owner_id WHERE
      (
        ((pLogId IS NULL) OR (l.log_id = pLogId)) AND
        ((pDeviceRelationshipId IS NULL) OR (dr.device_relationship_id = pDeviceRelationshipId)) AND
        ((pOwnerId IS NULL) OR (dr.owner_id = pOwnerId)) AND
        ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId)) AND
        ((pLogTitle IS NULL) OR (l.title = pLogTitle)) AND
        ((pLogType IS NULL) OR (l.type = pLogType)) AND
        ((pLogStatus IS NULL) OR (l.status = pLogStatus))
      );

    CREATE TEMP TABLE message_activities AS
      SELECT
      m.message_id as activity_id
      , m.message
      , m.type as message_type
      , m.create_date as message_create_date
      , m.trigger_event as message_trigger_event
      , dr.owner_id
      , dr.device_id
      , dr.device_relationship_id
      FROM message m INNER JOIN
      device_relationship dr ON dr.device_id = m.owner_id WHERE
      (
        ((pMessageId IS NULL) OR (m.message_id = pMessageId)) AND
        ((pDeviceRelationshipId IS NULL) OR (dr.device_relationship_id = pDeviceRelationshipId)) AND
        ((pOwnerId IS NULL) OR (dr.owner_id = pOwnerId)) AND
        ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId)) AND
        ((pMessageType IS NULL) OR (m.type <> ALL (pMessageType))) AND
        ((pMessageTriggerEvent IS NULL) OR (m.trigger_event = pMessageTriggerEvent))
      );

    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM
      message_activities ma FULL OUTER JOIN log_activities la ON ma.activity_id = la.activity_id;

    -- create a temp table to get the data
    CREATE TEMP TABLE activities_init AS
      SELECT
      la.activity_id
      , la.log_message
      , la.log_title
      , la.log_type
      , la.log_url
      , la.log_status
      , la.log_create_date
      , la.owner_id
      , la.device_id
      , la.device_relationship_id
      , ma.message
      , ma.message_type
      , ma.message_create_date
      , ma.message_trigger_event
      FROM
      message_activities ma FULL OUTER JOIN log_activities la ON ma.activity_id = la.activity_id
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
    *
    , totalRows
    FROM
    activities_init a;

END;
$BODY$
LANGUAGE plpgsql;
