-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_sleep_quality_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_sleep_quality_analytics(
        pDeviceId varchar(32)
        , pDay date
    )
RETURNS TABLE(
    sleep_quality integer
    , sleep_quality_null_reason varchar(32)
  )
AS
$BODY$
DECLARE
  pSleepTime timestamp without time zone default null;
  pWakeupTime timestamp without time zone default null;
  pTotalDisruption integer;
  pSleepingTime integer;
  pTotalTimeAsleep integer;
  pDisruptionRow record;

  pSleepQuality integer;
BEGIN
    -- get the sleeping and the wake up time of the particular day.
    -- get sleep time
    SELECT
      a.date_value2
    INTO
      pSleepTime
    FROM analytics_value a WHERE
    ((pDeviceId IS NULL) OR (a.owner_id = pDeviceId)) AND
    a.date_value = (pDay || 'T' || '00:00:00')::timestamp AND
    a.type = 'S';

    -- get wake up time
    SELECT
      a.date_value2
    INTO
      pWakeupTime
    FROM analytics_value a WHERE
    ((pDeviceId IS NULL) OR (a.owner_id = pDeviceId)) AND
    a.date_value = (pDay || 'T' || '00:00:00')::timestamp + INTERVAL '1 day' AND
    a.type = 'W';

    CREATE TEMP TABLE sleep_disruption_events(
        disruption_start timestamp without time zone,
        disruption_end timestamp without time zone,
        disruption_zone varchar(64),
        disruption_interval integer
    );

    CREATE TEMP TABLE sleep_quality_value_init(
        sleep_quality integer,
        sleep_quality_null_reason varchar(32)
    );

    IF (pSleepTime IS NOT NULL AND pWakeupTime IS NOT NULL) THEN
      -- If there is a wake up time and a sleeping time, get all the events.
      INSERT INTO sleep_disruption_events
        SELECT
              e.create_date AS disruption_start
              , e.next_create_date AS disruption_end
              , e.zone AS disruption_zone
              , EXTRACT(epoch FROM((e.next_create_date - e.create_date)))::integer AS disruption_interval
        FROM (SELECT e.*,
                   lead(e.create_date) over (ORDER BY eyecare_id) AS next_create_date
           FROM eyecare e WHERE
            ((pDeviceId = NULL) OR (e.device_id = pDeviceId))  AND
            e.create_date BETWEEN pSleepTime AND pWakeupTime AND((
               (e.event_type_id = '20001' AND ((e.zone IN ('Living Room', 'Living room')) OR e.node_name IN ('Door sensor', 'door sensor') OR e.zone_code = 'LR') AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
               (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone IN ('Living Room', 'Living room')) OR e.zone_code = 'LR')) OR -- Bedroom motion sensor alarm on
               (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone = 'Master Bedroom') OR e.zone_code = 'MR')) OR -- Bedroom motion sensor alarm on
               (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone = 'Kitchen') OR e.zone_code = 'KI')) OR -- Kitchen  motion sensor alarm on
               (e.event_type_id IN ('20002', '20003', '20005') AND ((e.zone = 'Bathroom') OR e.zone_code = 'BT1')) OR -- Get only the sensor off in the bathroom
                (e.event_type_id IN ('20013')) -- Get BP HR Reading
                )
           )) e WHERE
           EXTRACT(epoch FROM((e.next_create_date - e.create_date)))::integer < 600 -- interval less than 10 minutes
           ORDER BY eyecare_id;

          -- get the total sleeping time
          pSleepingTime = EXTRACT(epoch FROM((pWakeupTime - pSleepTime)))::integer;

          -- get the total disruption time
          pTotalDisruption = 0;
          FOR pDisruptionRow IN SELECT * from sleep_disruption_events LOOP
            --loop through all the record
            pTotalDisruption = pTotalDisruption + pDisruptionRow.disruption_interval;
          END LOOP;

          -- get the total time asleep
          pTotalTimeAsleep = pSleepingTime - pTotalDisruption;

          -- get the sleep quality
          pSleepQuality = round((pTotalTimeAsleep * 100) / pSleepingTime);

          INSERT INTO sleep_quality_value_init VALUES (pSleepQuality, null);
      ELSE
          IF pSleepTime IS NULL THEN
            INSERT INTO sleep_quality_value_init VALUES (null, 'away');
          ELSE
            INSERT INTO sleep_quality_value_init VALUES (null, null);
          END IF;
      END IF;

      RETURN QUERY
        SELECT * FROM sleep_quality_value_init;


END;
$BODY$
LANGUAGE plpgsql;
