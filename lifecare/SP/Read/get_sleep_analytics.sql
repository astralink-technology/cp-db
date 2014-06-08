-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_sleep_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_sleep_analytics(
        pDeviceId varchar(32)
        , pDay date
    )
RETURNS TABLE(
    sleeping_time timestamp without time zone
    , analytics_date date
    , device_id varchar(32)
  )
AS
$BODY$
DECLARE
    pSleepingTime timestamp without time zone DEFAULT NULL;
BEGIN

    -- create a temp table to get the data
    CREATE TEMP TABLE sleep_analytics_temp(
        sleeping_time timestamp without time zone
    );

    SELECT e.create_date INTO
      pSleepingTime
    FROM (
      SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
      FROM eyecare e
      WHERE (
       (e.node_name = 'Door sensor' AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
       (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
       (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
       (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
       ) AND
       e.create_date BETWEEN (pDay  || 'T' || '23:00')::timestamp AND ((pDay || 'T' || '05:00')::timestamp + INTERVAL '1 day') AND
     ((pDeviceId IS NULL) OR (e.device_id = pDeviceId)) AND
      e.event_type_id NOT IN  ('20010', '20004')
      ORDER BY e.create_date ASC
    ) e
    WHERE e.next_create_date > e.create_date + 2 * INTERVAL '1 hour'
    LIMIT 1;

    IF pSleepingTime IS NULL THEN
          INSERT INTO sleep_analytics_temp (sleeping_time)
            SELECT
              NULL AS sleeping_time;
    ELSE
          INSERT INTO sleep_analytics_temp (sleeping_time)
            SELECT
              pSleepingTime;
    END IF;

    RETURN QUERY
      SELECT
        *
        , pDay
        , pDeviceId
      FROM sleep_analytics_temp;
END;
$BODY$
LANGUAGE plpgsql;
