-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_at_home_duration_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_at_home_duration_analytics(
        pDeviceId varchar(32)
        , pDay date
    )
RETURNS TABLE (
      away_start timestamp without time zone
      , away_end timestamp without time zone
      , away_count integer
      , wakeup_time timestamp without time zone
      , sleeping_time timestamp without time zone
      , day_at_home_duration integer
      , night_at_home_duration integer
      , day_away_duration integer
      , night_away_duration integer
      , day_duration integer
      , night_duration integer
      , day_at_home_percentage integer
      , night_at_home_percentage integer
)
-- RETURNS TABLE (
--       day_at_home_duration integer
--       , night_at_home_duration integer
--       , wakeup_time timestamp without time zone
--       , sleeping_time timestamp without time zone
-- )
AS
$BODY$
DECLARE
    pDeploymentDate date default '2014-04-01';

    pWakeupTime timestamp without time zone default null;
    pSleepingTime timestamp without time zone default null;

    pDayOverlaps boolean default false;
    pNightOverlaps boolean default false;

    pNightStart timestamp without time zone;
    pNightEnd timestamp without time zone;
    pNight2Start timestamp without time zone;
    pNight2End timestamp without time zone;

    pDayStart timestamp without time zone;
    pDayEnd timestamp without time zone;
    pDay2Start timestamp without time zone;
    pDay2End timestamp without time zone;

    lastUserEventTypeId varchar(64);
    lastUserExtraData varchar(64);

    oDayAwayDuration integer;
    oNightAwayDuration integer;
    oDayDuration integer;
    oNightDuration integer;

    oEventCount integer;
    oDayAtHomeDuration integer;
    oNightAtHomeDuration integer;

    oDayAtHomePercentage integer;
    oNightAtHomePercentage integer;

    aRow record;
BEGIN
  -- Create a temp table to store all the days that has not been analyze
  CREATE TEMP TABLE IF NOT EXISTS away_value_init (
      away_start timestamp without time zone
      , away_end timestamp without time zone
      , away_count integer
  ) ON COMMIT DROP;

    -- get the deployment date of the device
    SELECT
      deployment_date
    INTO
      pDeploymentDate
    FROM device WHERE device_id = pDeviceId;

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

  -- find how long the elderly stays at home for the day
  INSERT INTO away_value_init (away_start, away_end, away_count)
      SELECT date_value2, date_value3, int_value FROM analytics_value WHERE owner_id = pDeviceId AND type = 'A' AND date_value = pDay ORDER BY int_value ASC;

  -- RETURN oAtHomeDuration;
  IF pWakeupTime IS NOT NULL AND pSleepingTime IS NOT NULL THEN
    oDayAtHomeDuration = 0;
    oNightAtHomeDuration = 0;

    -- Find the day length
    IF (pDayOverlaps = true) THEN
      oDayDuration = (EXTRACT (EPOCH FROM (((pDay || 'T' || '23:59')::timestamp - pWakeupTime) + (pSleepingTime - (pDay || 'T' || '00:00')::timestamp))))::integer;
    ELSEIF (pNightOverlaps = true) THEN
      oDayDuration = (EXTRACT (EPOCH FROM (pSleepingTime - pWakeupTime)))::integer;
    END IF;

    -- Find the night length
    IF (pNightOverlaps = true) THEN
      oNightDuration = (EXTRACT (EPOCH FROM (((pDay || 'T' || '23:59')::timestamp - pSleepingTime) + (pWakeupTime - (pDay || 'T' || '00:00')::timestamp))))::integer;
    ELSEIF (pDayOverlaps = true ) THEN
      oNightDuration = (EXTRACT (EPOCH FROM (pWakeupTime - pSleepingTime)))::integer;
    END IF;

    -- get all the events of the day or the last event of the day and to check user is at home
    SELECT
      COUNT(*)
    INTO
      oEventCount
    FROM eyecare e WHERE (
       (
           (e.node_name IN ('Door sensor', 'door sensor', 'Door Sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
            (e.event_type_id IN ('20002', '20003', '20004') AND (e.zone = 'Master Bedroom' OR e.zone_code = 'MB')) OR -- Bedroom motion sensor alarm on
            (e.event_type_id IN ('20002', '20003', '20004') AND (e.zone = 'Kitchen' OR e.zone_code = 'KI')) OR -- Kitchen  motion sensor alarm on
            (e.event_type_id IN ('20002', '20003', '20005') AND (e.zone = 'Bathroom' OR e.zone_code = 'BT1')) OR -- Get only the sensor off in the bathroom
           (e.event_type_id IN ('20013')) -- Get BP HR Reading
       ) AND
      (e.device_id = pDeviceId) AND
      (e.create_date BETWEEN (pDay || ' ' || '00:00:00')::timestamp AND (pDay || ' ' || '23:59:59')::timestamp)
    );

    -- get the last event of the day to check if user is at home on that day
    SELECT
      ey.event_type_id
      , ey.extra_data
    INTO
      lastUserEventTypeId
      , lastUserExtraData
    FROM eyecare ey
    WHERE
       (
           (ey.node_name IN ('Door sensor', 'door sensor', 'Door Sensor') AND ey.event_type_id = '20001' AND ey.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
            (ey.event_type_id IN ('20002', '20003', '20004') AND (ey.zone = 'Master Bedroom' OR ey.zone_code = 'MB')) OR -- Bedroom motion sensor alarm on
            (ey.event_type_id IN ('20002', '20003', '20004') AND (ey.zone = 'Kitchen' OR ey.zone_code = 'KI')) OR -- Kitchen  motion sensor alarm on
            (ey.event_type_id IN ('20002', '20003', '20005') AND (ey.zone = 'Bathroom' OR ey.zone_code = 'BT1')) OR -- Get only the sensor off in the bathroom
           (ey.event_type_id IN ('20013')) -- Get BP HR Reading
       ) AND
      ey.create_date BETWEEN (pDeploymentDate  || 'T' || '00:00')::timestamp AND ((pDay || 'T' || '23:59')::timestamp) AND
      ey.device_id = pDeviceId
    ORDER BY ey.create_date DESC LIMIT 1;

    IF oEventCount < 1 AND lastUserEventTypeId = '20001' AND lastUserExtraData = 'Alarm Off' THEN
      -- user is away from home for the whole day.
        -- user is away from home for the whole day. The day away is equivalent to the day window. The night away is equivalent to the night window
        oDayAtHomeDuration = 0;
        oNightAtHomeDuration = 0;
        oDayAtHomePercentage = 0;
        oNightAtHomePercentage = 0;
        oDayAwayDuration = oDayDuration;
        oNightAwayDuration = oNightDuration;
    ELSE

      -- Get the intervals for the night
      IF (pNightOverlaps = true) THEN
        pNightStart = pSleepingTime;
        pNightEnd = (pDay || 'T' || '23:59')::timestamp;
        pNight2Start = (pDay || 'T' || '00:00')::timestamp;
        pNight2End = pWakeupTime;

        pDayStart = pWakeupTime;
        pDayEnd = pSleepingTime;

      ELSEIF (pDayOverlaps = true) THEN

        pDayStart = pWakeupTime;
        pDayEnd = (pDay || 'T' || '23:59')::timestamp;
        pDay2Start = (pDay || 'T' || '00:00')::timestamp;
        pDay2End = pSleepingTime;

        pNightStart = pSleepingTime;
        pNightEnd = pWakeupTime;

      ELSE
        pDayStart = pWakeupTime;
        pDayEnd = pSleepingTime;

        pNightStart = pSleepingTime;
        pNightEnd = pWakeupTime;
      END IF;

      oDayAwayDuration = 0; -- reset temp storage of away mode;
      oNightAwayDuration = 0; -- reset temp storage of away mode;

      -- get the duration of each outing
      FOR aRow IN SELECT * FROM away_value_init LOOP
        -- Get the away duration for the night and day
        -- 3 scenarios for the time, day overlaps, night overlaps and normal
          CASE
            -- SCENARIO 1 - Day Overlaps
            WHEN (pDayOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pDayStart AND pDayEnd) AND (aRow.away_end BETWEEN pDayStart AND pDayEnd) THEN
              -- day overlap, goes out and return home during the standard day time
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - aRow.away_start)))::integer;
            WHEN (pDayOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pDay2Start AND pDay2End) AND (aRow.away_end BETWEEN pDay2Start AND pDay2End) THEN
              -- day overlap, goes out and return home during the overlapped day time
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - aRow.away_start)))::integer;
            WHEN (pDayOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pNightStart AND pNightEnd) AND (aRow.away_end BETWEEN pNightStart AND pNightEnd) THEN
              -- day overlap, goes out and return home during the standard night time
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - aRow.away_start)))::integer;
            WHEN (pDayOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pDay2Start AND pDay2End) AND (aRow.away_end BETWEEN pNightStart AND pNightEnd) THEN
              -- day overlap, goes out on the overlapped day time (late night after 12) and return homes during the standard night time
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (pNightStart - aRow.away_start)))::integer;
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - pNightStart)))::integer;
            WHEN (pDayOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pDay2Start AND pDay2End) AND (aRow.away_end BETWEEN pDayStart AND pDayEnd) THEN
              -- day overlap, goes out on the overlapped day time (late night after 12) and return homes during the standard day time
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (pNightStart - aRow.away_start)))::integer + (EXTRACT (EPOCH FROM (aRow.away_end - pNightEnd)))::integer;
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pNightEnd - pNightStart)))::integer;
            WHEN (pDayOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pNightStart AND pNightEnd) AND (aRow.away_end BETWEEN pDayStart AND pDayEnd) THEN
              -- day overlap, goes out during the standard night time and return home during the standard day time
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - pNightEnd)))::integer;
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pNightEnd - aRow.away_start)))::integer;
            WHEN (pDayOverlaps = true) AND (aRow.away_start IS NULL and aRow.away_end IS NOT NULL) AND (aRow.away_end BETWEEN pDay2Start AND pDay2End) THEN
              -- day overlap, was away since yesterday, return home during the overlapped day time
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - (pDay || 'T' || '00:00')::timestamp)))::integer;
            WHEN (pDayOverlaps = true) AND (aRow.away_start IS NULL and aRow.away_end IS NOT NULL) AND (aRow.away_end BETWEEN pNightStart AND pNightEnd) THEN
              -- day overlap, was away since yesterday, return home during the standard night time
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (pNightStart - (pDay || 'T' || '00:00')::timestamp)))::integer;
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - pNightStart)))::integer;
            WHEN (pDayOverlaps = true) AND (aRow.away_start IS NULL and aRow.away_end IS NOT NULL) AND (aRow.away_end BETWEEN pDayStart AND pDayEnd) THEN
              -- day overlap, was away since yesterday, return home during the standard day time
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (pNightStart - (pDay || 'T' || '00:00')::timestamp)))::integer + (EXTRACT (EPOCH FROM (aRow.away_end - pNightEnd)))::integer;
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pNightEnd - pNightStart)))::integer;
            WHEN (pDayOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NULL) AND (aRow.away_start BETWEEN pDay2Start AND pDay2End) THEN
              -- day overlap, goes out during the overlapped day and does not return home
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (pNightStart - aRow.away_start)))::integer + (EXTRACT (EPOCH FROM ((pDay || 'T' || '23:59')::timestamp - pNightEnd)))::integer;
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pNightEnd - pNightStart)))::integer;
            WHEN (pDayOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NULL) AND (aRow.away_start BETWEEN pNightStart AND pNightEnd) THEN
              -- day overlap, goes out during the night time and does not return home
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM ((pDay || 'T' || '23:59')::timestamp - pNightEnd)))::integer;
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pNightEnd - aRow.away_start)))::integer;
            WHEN (pDayOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NULL) AND (aRow.away_start BETWEEN pDayStart AND pDayEnd) THEN
              -- day overlap, goes out during the day and does not return home
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM ((pDay || 'T' || '23:59')::timestamp - aRow.away_start)))::integer;

            -- SCENARIO 2 - Night Overlaps
            WHEN (pNightOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pNight2Start AND pNight2End) AND (aRow.away_end BETWEEN pNight2Start AND pNight2End) THEN
              -- night overlap, goes out and return home during the standard night time
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - aRow.away_start)))::integer;
            WHEN (pNightOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pNightStart AND pNightEnd) AND (aRow.away_end BETWEEN pNight2Start AND pNightEnd) THEN
              -- night overlap, goes out and return home during the overlapped night time
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - aRow.away_start)))::integer;
            WHEN (pNightOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pDayStart AND pDayEnd) AND (aRow.away_end BETWEEN pDayStart AND pDayEnd) THEN
              -- night overlap, goes out and return home during the standard day time
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - aRow.away_start)))::integer;
            WHEN (pNightOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pNight2Start AND pNight2End) AND (aRow.away_end BETWEEN pDayStart AND pDayEnd) THEN
              -- night overlap, goes out during the standard night time and return home during the standard day time
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pNight2End - aRow.away_start)))::integer;
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - pNight2End)))::integer;
            WHEN (pNightOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pNight2Start AND pNight2End) AND (aRow.away_end BETWEEN pNightStart AND pNightEnd) THEN
              -- night overlap, goes out during the standard night time and return home during the overlapped night time
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pNight2End - aRow.away_start)))::integer + (EXTRACT (EPOCH FROM (aRow.away_end - pNightStart)))::integer;
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (pDayEnd - pDayStart)))::integer;
            WHEN (pNightOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pDayStart AND pDayEnd) AND (aRow.away_end BETWEEN pNightStart AND pNightEnd) THEN
              -- night overlap, goes out during the standard day time and return home during the overlapped night time
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - pNightStart)))::integer;
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (pDayEnd - aRow.away_start)))::integer;
            WHEN (pNightOverlaps = true) AND (aRow.away_start IS NULL and aRow.away_end IS NOT NULL) AND (aRow.away_end BETWEEN pNight2Start AND pNight2End) THEN
              -- night overlap, was away since yesterday and return home during the standard night time
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - (pDay || 'T' || '00:00')::timestamp)))::integer;
            WHEN (pNightOverlaps = true) AND (aRow.away_start IS NULL and aRow.away_end IS NOT NULL) AND (aRow.away_end BETWEEN pDayStart AND pDayEnd) THEN
              -- night overlap, was away since yesterday and return home during the standard day time
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pDayStart - (pDay || 'T' || '00:00')::timestamp)))::integer;
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - pDayStart)))::integer;
            WHEN (pNightOverlaps = true) AND (aRow.away_start IS NULL and aRow.away_end IS NOT NULL) AND (aRow.away_end BETWEEN pNightStart AND pNightEnd) THEN
              -- night overlap, was away since yesterday and return home during the overlapped night time
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pDayStart - (pDay || 'T' || '00:00')::timestamp)))::integer + (EXTRACT (EPOCH FROM (aRow.away_end - pNightStart)))::integer ;
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (pDayEnd - pDayStart)))::integer;
            WHEN (pNightOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NULL) AND (aRow.away_start BETWEEN pNight2Start AND pNight2End) THEN
              -- night overlap, goes out during the standard night time and does not return home
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pDayStart - aRow.away_start)))::integer + (EXTRACT (EPOCH FROM ((pDay || 'T' || '23:59')::timestamp - pNightStart)))::integer ;
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (pDayEnd - pDayStart)))::integer;
            WHEN (pNightOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NULL) AND (aRow.away_start BETWEEN pDayStart AND pDayEnd) THEN
              -- night overlap, goes out during the standard day time and does not return home
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM ((pDay || 'T' || '23:59')::timestamp - pNightStart)))::integer ;
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (pDayEnd - aRow.away_start)))::integer;
            WHEN (pNightOverlaps = true) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NULL) AND (aRow.away_start BETWEEN pNightStart AND pNightEnd) THEN
              -- night overlap, goes out during the overlapped night time and does not return home
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM ((pDay || 'T' || '23:59')::timestamp - aRow.away_start)))::integer;

            -- SCENARIO 3 - No Overlaps
            WHEN (pNightOverlaps = false AND pDayOverlaps = false) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pDayStart AND pDayEnd) AND (aRow.away_end BETWEEN pDayStart AND pDayEnd) THEN
              -- does not overlaps, goes out during the standard day time and return during the standard day time
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - aRow.away_start)))::integer;
            WHEN (pNightOverlaps = false AND pDayOverlaps = false) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pNightStart AND pNightEnd) AND (aRow.away_end BETWEEN pNightStart AND pNightEnd) THEN
              -- does not overlaps, goes out during the standard day time and return during the standard night time
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - aRow.away_start)))::integer;
            WHEN (pNightOverlaps = false AND pDayOverlaps = false) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NOT NULL) AND (aRow.away_start BETWEEN pDayStart AND pDayEnd) AND (aRow.away_end BETWEEN pNightStart AND pNightEnd) THEN
              -- does not overlaps, goes out during the standard day time and return during the standard night time
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - pDayStart)))::integer;
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pDayStart - aRow.away_start)))::integer;
            WHEN (pNightOverlaps = false AND pDayOverlaps = false) AND (aRow.away_start IS NULL and aRow.away_end IS NOT NULL) AND (aRow.away_end BETWEEN pNightStart AND pNightEnd) THEN
              -- does not overlaps, was away since yesterday and return home during the standard night time
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - (pDay || 'T' || '00:00')::timestamp)))::integer;
            WHEN (pNightOverlaps = false AND pDayOverlaps = false) AND (aRow.away_start IS NULL and aRow.away_end IS NOT NULL) AND (aRow.away_end BETWEEN pDayStart AND pDayEnd) THEN
              -- does not overlaps, was away since yesterday and return home during the standard day time
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pNightEnd - (pDay || 'T' || '00:00')::timestamp)))::integer;
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM (aRow.away_end - pDayStart)))::integer;
            WHEN (pNightOverlaps = false AND pDayOverlaps = false) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NULL) AND (aRow.away_start BETWEEN pNightStart AND pNightEnd) THEN
              -- does not overlaps, goes out during the night time and does not return home
              oNightAwayDuration = oNightAwayDuration + (EXTRACT (EPOCH FROM (pNightEnd - aRow.away_start)))::integer;
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM ((pDay || 'T' || '23:59')::timestamp - pDayStart)))::integer;
            WHEN (pNightOverlaps = false AND pDayOverlaps = false) AND (aRow.away_start IS NOT NULL and aRow.away_end IS NULL) AND (aRow.away_start BETWEEN pDayStart AND pDayEnd) THEN
              -- does not overlaps, goes out during the day time and does not return home
              oDayAwayDuration = oDayAwayDuration + (EXTRACT (EPOCH FROM ((pDay || 'T' || '23:59')::timestamp - aRow.away_start)))::integer;

            -- IF all scenarios are not taken care of and still cannot get any values, its an invalid data point.
            ELSE
              oDayAwayDuration = 0;
              oNightAwayDuration = 0;
          END CASE;
      END LOOP;

      oDayAtHomeDuration = oDayDuration - oDayAwayDuration;
      oNightAtHomeDuration = oNightDuration - oNightAwayDuration;

      oDayAtHomePercentage = oDayAtHomeDuration * 100 / oDayDuration;
      oNightAtHomePercentage =  oNightAtHomeDuration * 100 / oNightDuration;
    END IF;

  ELSE
    oDayAtHomeDuration = null;
    oNightAtHomeDuration = null;
    oDayAtHomePercentage = 0;
    oNightAtHomePercentage = 0;
  END IF;

  RETURN QUERY
    SELECT
      *
      , pWakeupTime
      , pSleepingTime
      , oDayAtHomeDuration
      , oNightAtHomeDuration
      , oDayAwayDuration
      , oNightAwayDuration
      , oDayDuration
      , oNightDuration
      , oDayAtHomePercentage
      , oNightAtHomePercentage
    FROM away_value_init;

END;
$BODY$
LANGUAGE plpgsql;