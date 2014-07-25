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
    , prev_row_create_date timestamp without time zone
    , next_row_create_date timestamp without time zone
    , duration_apart integer
    , event_type_id varchar(64)
    , event_type_name varchar(64)
    , node_name varchar(64)
    , zone varchar(64)
    , create_date timestamp without time zone
    , extra_data varchar(64)
    , wakeup_time timestamp without time zone
    , sleeping_time timestamp without time zone
    , sleeping_time_hour integer
    , day_duration integer
    , night_duration integer
    , away_duration integer
    , day_active integer
    , night_active integer
  )
AS
$BODY$
DECLARE
  pWakeupTime timestamp without time zone default null;
  pSleepingTime timestamp without time zone default null;

  pDayDuration integer;
  pNightDuration integer;
  pAwayDuration integer;
  pAwayDurationTemp integer;

  pActivityLevel integer;

  nRow record;
  dRow record;
  aRow record;

  awayRowCount integer;
  lastUserEventTypeId varchar(64);
  lastUserExtraData varchar(64);

  dTempDuration integer;
  nTempDuration integer;

  dActive integer;
  nActive integer;
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
      -- get all the day activities
      CREATE TEMP TABLE day_activities_temp AS
        SELECT
          e.eyecare_id
          , lag(e.create_date)  over (ORDER BY e.eyecare_id) AS prev_row_create_date
          , lead(e.create_date)  over (ORDER BY e.eyecare_id) AS next_row_create_date
          , EXTRACT (EPOCH FROM ((lead(e.create_date) over (ORDER BY e.eyecare_id)) - e.create_date))::integer AS duration_apart
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

      -- get the day length
      IF (EXTRACT (HOUR FROM pSleepingTime)::integer < 12) THEN
        pDayDuration = (EXTRACT (EPOCH FROM (((pDay || 'T' || '23:59')::timestamp - pWakeupTime) + (pSleepingTime - (pDay || 'T' || '00:00')::timestamp))))::integer;
      ELSEIF (EXTRACT (HOUR FROM pSleepingTime)::integer > 12) THEN
        pDayDuration = (EXTRACT (EPOCH FROM (pSleepingTime - pWakeupTime)))::integer;
      END IF;

      -- get all the night activities
      CREATE TEMP TABLE night_activities_temp AS
        SELECT
          e.eyecare_id
          , lag(e.create_date) over (ORDER BY e.eyecare_id) AS prev_row_create_date
          , lead(e.create_date) over (ORDER BY e.eyecare_id) AS next_row_create_date
          , EXTRACT (EPOCH FROM ((lead(e.create_date) over (ORDER BY e.eyecare_id)) - e.create_date))::integer AS duration_apart
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


      -- get the night length
      IF (EXTRACT (HOUR FROM pSleepingTime)::integer > 12) THEN
        pNightDuration = (EXTRACT (EPOCH FROM (((pDay || 'T' || '23:59')::timestamp - pSleepingTime) + (pWakeupTime - (pDay || 'T' || '00:00')::timestamp))))::integer;
      ELSEIF (EXTRACT (HOUR FROM pSleepingTime)::integer < 12) THEN
        pNightDuration = (EXTRACT (EPOCH FROM (pWakeupTime - pSleepingTime)))::integer;
      END IF;


      -- Find the total activity for the day
      dTempDuration = 0;
      dActive = 0;
      -- For each of the day duration's row get the duration calculation
      FOR dRow IN SELECT * from day_activities_temp LOOP
        IF dRow.duration_apart IS NOT NULL AND dRow.duration_apart < 300 THEN
          dTempDuration = dTempDuration + dRow.duration_apart; -- add on to the temp stack if elderly is active within 5 minutes of motion detect
        ELSE
          dTempDuration = dTempDuration + 300; -- add 5 minutes to the temp stack for last motion detected
          dActive = dActive + dTempDuration; -- add the temp stack to the total activity level
          dTempDuration = 0; -- clear the temp stack
        END IF;
      END LOOP;

      -- Find the total activity for the night
      nTempDuration = 0;
      nActive = 0;
      -- For each of the day duration's row get the duration calculation
      FOR nRow IN SELECT * from night_activities_temp LOOP
        IF nRow.duration_apart IS NOT NULL AND nRow.duration_apart < 300 THEN
          nTempDuration = nTempDuration + nRow.duration_apart; -- add on to the temp stack if elderly is active within 5 minutes of motion detect
        ELSE
          nTempDuration = nTempDuration + 300; -- add 5 minutes to the temp stack for last motion detected
          nActive = nActive + nTempDuration; -- add the temp stack to the total activity level
          nTempDuration = 0; -- clear the temp stack
        END IF;
      END LOOP;

      -- Get the total away duration
      CREATE TEMP TABLE away_values_temp AS
          SELECT * FROM get_away_analytics(pDeviceId, pDay);

      SELECT COUNT(*) INTO awayRowCount FROM away_values_temp;

      pAwayDuration = 0;

      IF awayRowCount > 0 THEN
        -- get the duration of each outing
        FOR aRow IN SELECT * FROM away_values_temp LOOP
          pAwayDurationTemp = 0; -- reset temp storage of away mode;

          IF aRow.away_start IS NULL THEN
            -- if the user returned home from away mode
            pAwayDurationTemp = (EXTRACT (EPOCH FROM (aRow.away_end - (pDay || 'T' || '00:00')::timestamp)))::integer;
          ELSEIF aRow.away_end IS NULL THEN
            -- if user is out till next day
            pAwayDurationTemp = (EXTRACT (EPOCH FROM ((pDay || 'T' || '23:59')::timestamp - aRow.away_start)))::integer;
          ELSE
            -- normal calculation of away mode
            pAwayDurationTemp = (EXTRACT (EPOCH FROM (aRow.away_end - aRow.away_start)))::integer;
          END IF;

          pAwayDuration = pAwayDuration + pAwayDurationTemp;
        END LOOP;
      ELSE

        -- Check if user is at home.
        SELECT
          ey.event_type_id
          , ey.extra_data
        INTO
          lastUserEventTypeId
          , lastUserExtraData
        FROM eyecare ey
        WHERE
          ey.create_date BETWEEN (pDay  || 'T' || '00:00')::timestamp AND ((pDay || 'T' || '23:59')::timestamp) AND
          ey.device_id = pDeviceId
        ORDER BY ey.create_date DESC LIMIT 1;

        IF lastUserEventTypeId = '20001' AND extra_data = 'Alarm Off' THEN
          -- user is away from home for the whole day. Do no calculate at all
          pAwayDuration = null;
        ELSE
          -- user is at home for the whole day.
          pAwayDuration = 0;
        END IF;
      END IF;

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
         , pDayDuration
         , pNightDuration
         , pAwayDuration
         , dActive
         , nActive
      FROM day_activities_temp;

    DROP TABLE away_values_temp;
END;
$BODY$
LANGUAGE plpgsql;
