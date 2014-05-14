-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_bathroom_usage_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_bathroom_usage_analytics(
        pDeviceId varchar(32)
        , pDay date
    )
RETURNS TABLE(
--         create_date timestamp without time zone,
--         next_create_date timestamp without time zone,
--         next_zone varchar(64),
--         prev_zone varchar(64)
--         duration integer
        bathroom_usage_start timestamp without time zone,
        bathroom_usage_end timestamp without time zone,
        bathroom_usage_interval integer
  )
AS
$BODY$
DECLARE
  bRow record;
  bTempDuration integer;
  bTempBathroomUsageStart timestamp without time zone;
BEGIN

    CREATE TEMP TABLE bathroom_usage_intervals_raw AS
      SELECT e.create_date, e.next_create_date, e.next_zone, e.prev_zone, EXTRACT(epoch FROM((e.next_create_date - e.create_date)))::integer AS duration
      FROM (SELECT e.*,
               lead(e.create_date) over (ORDER BY eyecare_id) AS next_create_date,
               lead(e.event_type_id) over (ORDER BY eyecare_id) AS next_event_type,
               lead(e.zone) over (ORDER BY eyecare_id) AS next_zone,
               lag(e.zone) over (ORDER BY eyecare_id) AS prev_zone
        FROM eyecare e WHERE
        ((pDeviceId = NULL) OR (e.device_id = pDeviceId))  AND
        e.create_date BETWEEN (pDay  || 'T' || '00:00')::timestamp AND ((pDay || 'T' || '23:59')::timestamp) AND((
            (e.node_name = 'Door sensor' AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
            (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
            (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
            (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Bathroom')) AND
            (e.eyecare_id NOT IN
              (
                SELECT ee.eyecare_id
                                  FROM (
                                    SELECT ee.*,
                                           lead(ee.event_type_id) over (ORDER BY ee.eyecare_id) AS next_event_type_id,
                                           lead(ee.create_date) over (ORDER BY ee.eyecare_id) AS next_create_date
                                    FROM eyecare ee WHERE
                                    ee.create_date BETWEEN (pDay  || 'T' || '00:00')::timestamp AND ((pDay || 'T' || '23:59')::timestamp) AND
                                    ((pDeviceId = NULL) OR (ee.device_id = pDeviceId))
                                   ) ee WHERE
                                  ee.zone = 'Bathroom' AND
                                 (ee.event_type_id IN ('20010') OR (ee.event_type_id = '20004' AND next_event_type_id = '20010'))
              )
            )
       )) e
       WHERE e.zone = 'Bathroom'
       ORDER BY eyecare_id;


    CREATE TEMP TABLE bathroom_usage_intervals(
        bathroom_usage_start timestamp without time zone,
        bathroom_usage_end timestamp without time zone,
        bathroom_usage_interval integer
    );

    bTempDuration := 0;
    FOR bRow IN SELECT * from bathroom_usage_intervals_raw LOOP
      --loop through all the record
      IF bRow.next_zone = 'Bathroom' THEN
          bTempDuration := bTempDuration + bRow.duration;
      ELSE
        bTempDuration := bTempDuration + bRow.duration;
        bTempBathroomUsageStart = bRow.create_date - bTempDuration * INTERVAL '1 sec';
        INSERT INTO bathroom_usage_intervals(bathroom_usage_start, bathroom_usage_end, bathroom_usage_interval) VALUES (bTempBathroomUsageStart, bRow.create_date, bTempDuration);
        --refresh the duration
        bTempDuration := 0;
      END IF;
    END LOOP;

    RETURN QUERY
      SELECT * FROM bathroom_usage_intervals;

END;
$BODY$
LANGUAGE plpgsql;