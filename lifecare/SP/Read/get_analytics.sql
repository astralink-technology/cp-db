-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_analytics(
       pEntityId varchar(32)
        , pZone varchar(64)
        , pDeviceId varchar(32)
        , pEventTypeId varchar(32)
        , pStartDateTime timestamp without time zone
        , pEndDateTime timestamp without time zone
    )
RETURNS TABLE(
    eyecare_id varchar(32)
    , event_type_name varchar(64)
    , event_type_id varchar(64)
    , node_id varchar(64)
    , node_name varchar(64)
    , zone varchar(64)
    , create_date timestamp without time zone
    , device_id varchar(32)
    , home_id varchar(32)
    , extra_data varchar(64)
    , entity_id varchar(32)
    , total_rows integer
  )
AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM eyecare;

    -- create a temp table to get the data
    CREATE TEMP TABLE eyecare_init AS
      SELECT
        e.eyecare_id
        , e.event_type_name
        , e.event_type_id
        , e.node_id
        , e.node_name
        , e.zone
        , e.create_date
        , e.device_id
        , e.home_id
        , e.extra_data
        , e.entity_id
          FROM eyecare e WHERE (
           (
             (e.node_name = 'Door sensor' AND e.event_type_id = '20001' AND e.extra_data = 'Alarm On') OR -- door sensor alarm report on door open "Alarm On"
             (e.event_type_id = '20004' AND e.node_name = 'Motion sensor') OR -- Bedroom motion sensor alarm on
             (e.event_type_id = '20004' AND e.node_name = 'kitchen sensor') OR -- Kitchen  motion sensor alarm on
             (e.event_type_id = '20004' AND e.node_name = 'Bathroom')
--              (
--                 e.eyecare_id NOT IN (
--                   SELECT ee.eyecare_id
--                   FROM (
--                         SELECT ee.*,
--                                lead(ee.event_type_id) over (ORDER BY ee.eyecare_id) AS prev_event_type_id,
--                                lead(ee.create_date) over (ORDER BY ee.eyecare_id) AS prev_create_date
--                         FROM eyecare ee WHERE
--                         ee.create_date BETWEEN pStartDateTime AND pEndDateTime AND
--                         ee.device_id = pDeviceId AND
--                        ) ee WHERE
--                   ee.event_type_id = '20004' AND
--                   ee.node_name = 'Bathroom'
--                   AND prev_event_type_id = '20010'
--                   AND prev_create_date >  ee.create_date - 1.5 * interval '1 minute'
--                )
--              )
           ) AND -- Bathroom motion sensor alarm on
          ((pEntityId IS NULL) OR (e.entity_id = pEntityId)) AND
          ((pZone IS NULL) OR (e.zone = pZone)) AND
          ((pDeviceId IS NULL) OR (e.device_id = pDeviceId)) AND
          ((pEventTypeId IS NULL) OR (e.event_type_id = pEventTypeId)) AND
          ((pZone IS NULL) OR (e.zone = pZone)) AND
          ((pStartDateTime IS NULL OR pEndDateTime IS NULL) OR (e.create_date BETWEEN pStartDateTime AND pEndDateTime)) -- might have syntax error
        )
      ORDER BY e.create_date ASC;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM eyecare_init;

END;
$BODY$
LANGUAGE plpgsql;
