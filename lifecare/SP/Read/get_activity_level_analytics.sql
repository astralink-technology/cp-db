-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_activity_level_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_activity_level_analytics(
        pDeviceId varchar(32)
        , pDay date
    )
RETURNS TABLE(
    -- activity_level integer
    eyecare_id varchar(32)
    , event_type_id varchar(64)
    , event_type_name varchar(64)
    , node_name varchar(64)
    , zone varchar(64)
    , create_date timestamp without time zone
    , extra_data varchar(64)
    , wakeup_time timestamp without time zone
    , sleeping_time timestamp without time zone
    , sleeping_time_hour integer
  )
AS
$BODY$
DECLARE
  pWakeupTime timestamp without time zone default null;
  pSleepingTime timestamp without time zone default null;

  pActivityLevel integer;
BEGIN
    -- get the wake up time
    SELECT
      (pDay || 'T' || EXTRACT (HOUR FROM  date_value2) || ':' || EXTRACT (MINUTE FROM date_value2))::timestamp
    INTO
      pWakeupTime
    FROM analytics_value
    WHERE
      type = 'W' AND
      date_value = (pDay || 'T' || '00:00')::timestamp AND
      owner_id = pDeviceId;

    -- get the sleep time
    SELECT
      (pDay || 'T' || EXTRACT (HOUR FROM  date_value2) || ':' || EXTRACT (MINUTE FROM date_value2))::timestamp
    INTO
      pSleepingTime
    FROM analytics_value
    WHERE
      type = 'S' AND
      date_value = (pDay || 'T' || '00:00')::timestamp AND
      owner_id = pDeviceId;


    -- if there are not sleep time or wake up time, user might be away. get the median wake up time and median sleeping time
    IF pWakeupTime IS NULL THEN
      SELECT
        (pDay || 'T' || EXTRACT (HOUR FROM  date_value2) || ':' || EXTRACT (MINUTE FROM date_value2))::timestamp
      INTO
        pWakeupTime
      FROM informative_analytics
      WHERE
        type = 'MW' AND
        date_value2 IS NOT NULL
      ORDER BY date_value DESC;
    END IF;

    IF pSleepingTime IS NULL THEN
      SELECT
        (pDay || 'T' || EXTRACT (HOUR FROM date_value2) || ':' || EXTRACT (MINUTE FROM date_value2))::timestamp
      INTO
        pSleepingTime
      FROM informative_analytics
      WHERE
        type = 'MS' AND
        date_value2 IS NOT NULL
      ORDER BY date_value DESC;
    END IF;

    -- if there are still no sleep time or wake up time, we use the core analytics value
    IF pWakeupTime IS NULL THEN
      SELECT
        (pDay || 'T' || EXTRACT (HOUR FROM date_value) || ':' || EXTRACT (MINUTE FROM date_value))::timestamp
      INTO
        pWakeupTime
      FROM core_analytics
      WHERE
        type = 'MW';
    END IF;

    IF pSleepingTime IS NULL THEN
      SELECT
        (pDay || 'T' || EXTRACT (HOUR FROM date_value) || ':' || EXTRACT (MINUTE FROM date_value))::timestamp
      INTO
        pSleepingTime
      FROM core_analytics
      WHERE
        type = 'MS';
    END IF;

    IF pWakeupTime IS NOT NULL AND pSleepingTime IS NOT NULL THEN
      CREATE TEMP TABLE day_activities_temp AS
        SELECT
          e.eyecare_id
          , e.event_type_id
          , e.event_type_name
          , e.node_name
          , e.zone
          , e.create_date
          , e.extra_data
        FROM eyecare e
        WHERE
          (
            (EXTRACT (HOUR FROM pSleepingTime)::integer < 12 AND e.create_date BETWEEN pWakeupTime AND (pDay || 'T' || '23:59')::timestamp) OR -- day activities which sleeping time that crosses the 12 am line
            (EXTRACT (HOUR FROM pSleepingTime)::integer < 12 AND e.create_date BETWEEN (pDay || 'T' || '00:00')::timestamp AND pSleepingTime) OR -- day activities which sleeping time that crosses the 12 am line
            (EXTRACT (HOUR FROM pSleepingTime)::integer > 12 AND e.create_date BETWEEN pWakeupTime AND pSleepingTime) -- normal day activities
          )
        AND ((pDeviceId = NULL) OR (e.device_id = pDeviceId))  AND (
              (e.node_name IN ('Door sensor', 'door sensor')  AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
              (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
              (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
              (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') OR -- Get only the sensor off in the bathroom
             (e.event_type_id IN ('20013')) -- Get BP HR Reading
           )
        ORDER BY eyecare_id;

      CREATE TEMP TABLE night_activities_temp AS
        SELECT
          e.eyecare_id
          , e.event_type_id
          , e.event_type_name
          , e.node_name
          , e.zone
          , e.create_date
          , e.extra_data
        FROM eyecare e
        WHERE
          (
            (EXTRACT (HOUR FROM pSleepingTime)::integer < 12 AND e.create_date BETWEEN pSleepingTime AND pWakeupTime) OR -- night activities which sleeping time that crosses the 12 am line
            (EXTRACT (HOUR FROM pSleepingTime)::integer > 12 AND e.create_date BETWEEN pSleepingTime AND (pDay || 'T' || '23:59')::timestamp) OR -- normal night activities before 12am
            (EXTRACT (HOUR FROM pSleepingTime)::integer > 12 AND e.create_date BETWEEN (pDay || 'T' || '00:00')::timestamp AND pWakeupTime) -- night activities after 12am
          )
        AND ((pDeviceId = NULL) OR (e.device_id = pDeviceId))  AND (
              (e.node_name IN ('Door sensor', 'door sensor')  AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
              (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
              (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
              (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') OR -- Get only the sensor off in the bathroom
             (e.event_type_id IN ('20013')) -- Get BP HR Reading
           )
        ORDER BY eyecare_id;
    ELSE
      -- if there are still no sleep time or wake up time, i am going home
      pActivityLevel = null;
    END IF;

    RETURN QUERY
      SELECT
        *
         , pWakeupTime
         , pSleepingTime
         , EXTRACT (HOUR FROM pSleepingTime)::integer
      FROM night_activities_temp;

--     DROP TABLE away_analytics_temp;
END;
$BODY$
LANGUAGE plpgsql;
