-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_night_inactivity_level_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_night_inactivity_level_analytics(
        pDeviceId varchar(32)
        , pDay date
    )
RETURNS TABLE(
  -- activity_level integer
      eyecare_id varchar(32)
      , inactivity_duration integer
      , next_row_create_date timestamp without time zone
      , prev_row_create_date timestamp without time zone
      , create_date timestamp without time zone
      , wakeup_time timestamp without time zone
      , sleep_time timestamp without time zone
)
AS
$BODY$
DECLARE
  aRow record;

  pWakeupTime timestamp without time zone default null;
  pSleepingTime timestamp without time zone default null;

  pDayOverlaps bool default false;
  pNightOverlaps bool default false;

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

  IF EXTRACT (HOUR FROM pSleepingTime)::integer < 12 THEN
    pDayOverlaps = true;
  ELSEIF EXTRACT (HOUR FROM pSleepingTime)::integer > 12 THEN
    pNightOverlaps = true;
  END IF;

  -- Get all the away timings (both away start and away end to filter off all the away from the inactivity levels
  CREATE TEMP TABLE away_start_end_timings_init(
      away_timing timestamp without time zone
  );
  DELETE FROM away_start_end_timings_init;

  CREATE TEMP TABLE IF NOT EXISTS away_timings_init (
    eyecare_id varchar(32),
    away_start timestamp without time zone,
    away_end timestamp without time zone
  )ON COMMIT DROP;
  DELETE FROM away_timings_init;

  INSERT INTO away_timings_init (eyecare_id, away_start, away_end)
    SELECT * FROM get_away_analytics(pDeviceId, pDay);

  FOR aRow IN SELECT * FROM away_timings_init LOOP
    IF aRow.away_start IS NOT NULL THEN
      INSERT INTO away_start_end_timings_init VALUES (aRow.away_start);
    END IF;

    IF aRow.away_end IS NOT NULL THEN
      INSERT INTO away_start_end_timings_init VALUES (aRow.away_end);
    END IF;
  END LOOP;

  -- Night inactivity level table init
  CREATE TEMP TABLE IF NOT EXISTS night_inactivity_level_init(
      eyecare_id varchar(32)
      , inactivity_duration integer
      , next_row_create_date timestamp without time zone
      , prev_row_create_date timestamp without time zone
      , create_date timestamp without time zone
  )ON COMMIT DROP;
  -- get all inactivity levels
  DELETE FROM night_inactivity_level_init;

  IF pDayOverlaps = true THEN

      INSERT INTO night_inactivity_level_init (eyecare_id, inactivity_duration, next_row_create_date, prev_row_create_date, create_date)
        SELECT
          ee.*
         FROM(
            SELECT
              e.eyecare_id
              , EXTRACT (EPOCH FROM (lead(e.create_date) over (ORDER BY e.eyecare_id)) - e.create_date)::integer - 300 AS inactivity_duration -- -5 minutes of settling down
              , lead(e.create_date)  over (ORDER BY e.eyecare_id) AS next_row_create_date
              , lag(e.create_date)  over (ORDER BY e.eyecare_id) AS prev_row_create_date
              , e.create_date
              FROM eyecare e WHERE e.device_id = pDeviceId AND
              (e.create_date BETWEEN (pDay || ' ' ||  '00:00:00')::timestamp AND (pDay || ' ' ||  '23:59:59')::timestamp) AND ((
                 (e.event_type_id = '20001' AND ((e.zone IN ('Living Room', 'Living room')) OR e.node_name IN ('Door sensor', 'door sensor') OR e.zone_code = 'LR') AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                 (e.event_type_id IN ('20004')AND ((e.zone IN ('Living Room', 'Living room')) OR e.zone_code = 'LR')) OR -- Living room motion detected
                 (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone = 'Master Bedroom') OR e.zone_code = 'MR')) OR -- Bedroom motion sensor alarm on
                 (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone = 'Kitchen') OR e.zone_code = 'KI')) OR -- Kitchen  motion sensor alarm on
                 (e.event_type_id IN ('20002', '20003', '20005') AND ((e.zone = 'Bathroom') OR e.zone_code = 'BT1')) OR -- Get only the sensor off in the bathroom
                 (e.event_type_id IN ('20013')) -- Get BP HR Reading
                    )
                     ))ee
        WHERE ee.inactivity_duration > 299 AND -- more than 5 minutes to consider inactive
        ee.create_date NOT IN (SELECT * FROM away_start_end_timings_init) AND
        ee.next_row_create_date NOT IN (SELECT * FROM away_start_end_timings_init) AND
        ee.prev_row_create_date NOT IN (SELECT * FROM away_start_end_timings_init) AND
        (ee.create_date BETWEEN pSleepingTime AND pWakeupTime);

  ELSEIF pNightOverlaps = true THEN

      INSERT INTO night_inactivity_level_init (eyecare_id, inactivity_duration, next_row_create_date, prev_row_create_date, create_date)
        SELECT
          ee.*
         FROM(
            SELECT
              e.eyecare_id
              , EXTRACT (EPOCH FROM (lead(e.create_date) over (ORDER BY e.eyecare_id)) - e.create_date)::integer - 300 AS inactivity_duration -- -5 minutes of settling down
              , lead(e.create_date)  over (ORDER BY e.eyecare_id) AS next_row_create_date
              , lag(e.create_date)  over (ORDER BY e.eyecare_id) AS prev_row_create_date
              , e.create_date
              FROM eyecare e WHERE e.device_id = pDeviceId AND
              (e.create_date BETWEEN (pDay || ' ' ||  '00:00:00')::timestamp AND (pDay || ' ' ||  '23:59:59')::timestamp) AND ((
                 (e.event_type_id = '20001' AND ((e.zone IN ('Living Room', 'Living room')) OR e.node_name IN ('Door sensor', 'door sensor') OR e.zone_code = 'LR') AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                 (e.event_type_id IN ('20004')AND ((e.zone IN ('Living Room', 'Living room')) OR e.zone_code = 'LR')) OR -- Living room motion detected
                 (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone = 'Master Bedroom') OR e.zone_code = 'MR')) OR -- Bedroom motion sensor alarm on
                 (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone = 'Kitchen') OR e.zone_code = 'KI')) OR -- Kitchen  motion sensor alarm on
                 (e.event_type_id IN ('20002', '20003', '20005') AND ((e.zone = 'Bathroom') OR e.zone_code = 'BT1')) OR -- Get only the sensor off in the bathroom
                 (e.event_type_id IN ('20013')) -- Get BP HR Reading
                    )
                     ))ee
        WHERE ee.inactivity_duration > 299 AND -- more than 5 minutes to consider inactive
        ee.create_date NOT IN (SELECT * FROM away_start_end_timings_init) AND
        ee.next_row_create_date NOT IN (SELECT * FROM away_start_end_timings_init) AND
        ee.prev_row_create_date NOT IN (SELECT * FROM away_start_end_timings_init) AND
        ((ee.create_date BETWEEN (pDay || ' ' ||  '00:00:00')::timestamp AND pWakeupTime) OR
        (ee.create_date BETWEEN pSleepingTime AND (pDay || ' ' || '23:59:59')::timestamp));
  ELSE
      INSERT INTO night_inactivity_level_init (eyecare_id, inactivity_duration, next_row_create_date, prev_row_create_date, create_date)
        SELECT
          ee.*
         FROM(
            SELECT
              e.eyecare_id
              , EXTRACT (EPOCH FROM (lead(e.create_date) over (ORDER BY e.eyecare_id)) - e.create_date)::integer - 300 AS inactivity_duration -- -5 minutes of settling down
              , lead(e.create_date) over (ORDER BY e.eyecare_id) AS next_row_create_date
              , lag(e.create_date) over (ORDER BY e.eyecare_id) AS prev_row_create_date
              , e.create_date
              FROM eyecare e WHERE e.device_id = pDeviceId AND
              (e.create_date BETWEEN (pDay || ' ' ||  '00:00:00')::timestamp AND (pDay || ' ' ||  '23:59:59')::timestamp) AND ((
                 (e.event_type_id = '20001' AND ((e.zone IN ('Living Room', 'Living room')) OR e.node_name IN ('Door sensor', 'door sensor') OR e.zone_code = 'LR') AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                 (e.event_type_id IN ('20004')AND ((e.zone IN ('Living Room', 'Living room')) OR e.zone_code = 'LR')) OR -- Living room motion detected
                 (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone = 'Master Bedroom') OR e.zone_code = 'MR')) OR -- Bedroom motion sensor alarm on
                 (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone = 'Kitchen') OR e.zone_code = 'KI')) OR -- Kitchen  motion sensor alarm on
                 (e.event_type_id IN ('20002', '20003', '20005') AND ((e.zone = 'Bathroom') OR e.zone_code = 'BT1')) OR -- Get only the sensor off in the bathroom
                 (e.event_type_id IN ('20013')) -- Get BP HR Reading
                    )
                     ))ee
        WHERE ee.inactivity_duration > 299 AND -- more than 5 minutes to consider inactive
        ee.create_date NOT IN (SELECT * FROM away_start_end_timings_init) AND
        ee.next_row_create_date NOT IN (SELECT * FROM away_start_end_timings_init) AND
        ee.prev_row_create_date NOT IN (SELECT * FROM away_start_end_timings_init) AND
        (ee.create_date BETWEEN (pDay || ' ' ||  '00:00:00')::timestamp AND pWakeupTime);
  END IF;

    RETURN QUERY
      SELECT
        *
        , pWakeupTime
        , pSleepingTime
      FROM night_inactivity_level_init;

END;
$BODY$
LANGUAGE plpgsql;
