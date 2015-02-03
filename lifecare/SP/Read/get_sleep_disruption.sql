-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_sleep_disruption' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_sleep_disruption(
        pDeviceId varchar(32)
        , pDay date
    )
RETURNS TABLE(
        disruption_start timestamp without time zone,
        disruption_end timestamp without time zone,
        disruption_zone varchar(64),
        disruption_interval integer,
        sleep_time timestamp without time zone,
        wakeup_time timestamp without time zone
  )
AS
$BODY$
DECLARE
  pSleepTime timestamp without time zone default null;
  pWakeupTime timestamp without time zone default null;
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
            e.create_date BETWEEN pSleepTime + INTERVAL '1 minute' AND pWakeupTime - INTERVAL '1 minute' AND((
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
      END IF;

    RETURN QUERY
      SELECT *, pSleepTime, pWakeupTime FROM sleep_disruption_events;

END;
$BODY$
LANGUAGE plpgsql;
