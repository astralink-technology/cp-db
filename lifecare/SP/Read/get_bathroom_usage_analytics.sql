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
          SELECT er.* FROM (
            SELECT e.eyecare_id
              , lag(e.create_date)  over (ORDER BY eyecare_id) AS prev_row_create_date
              , lead(e.create_date)  over (ORDER BY eyecare_id) AS next_row_create_date
              , e.create_date
              , e.next_create_date
              , e.current_zone
              , e.next_zone
              , EXTRACT(epoch FROM((e.next_create_date - e.create_date)))::integer + 24 AS duration
                  FROM (SELECT e.*,
                     lead(e.create_date) over (ORDER BY eyecare_id) AS next_create_date,
                     lead(e.event_type_id) over (ORDER BY eyecare_id) AS next_event_type,
                     lag(e.zone) over (ORDER BY eyecare_id) AS prev_zone,
                     e.zone as current_zone,
                     lead(e.zone) over (ORDER BY eyecare_id) AS next_zone
                FROM eyecare e WHERE
                 ((pDeviceId = NULL) OR (e.device_id = pDeviceId))  AND
                  e.create_date BETWEEN (pDay  || 'T' || '00:00')::timestamp AND ((pDay || 'T' || '23:59')::timestamp) AND((
                    (e.node_name IN ('Door sensor', 'door sensor')  AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                    (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                    (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                    (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom'))
                     )) e
                 WHERE e.current_zone = 'Bathroom'
                 AND (EXTRACT(epoch FROM((e.next_create_date - e.create_date)))::integer < 600) -- filter out values greater than 10 minutes as thats not possible
                 )er;


    CREATE TEMP TABLE bathroom_usage_intervals(
        bathroom_usage_start timestamp without time zone,
        bathroom_usage_end timestamp without time zone,
        bathroom_usage_interval integer
    );

    bTempDuration := 0;
    FOR bRow IN SELECT * from bathroom_usage_intervals_raw LOOP

      --loop through all the record
      IF bRow.next_zone = 'Bathroom' THEN
          bTempDuration = bTempDuration + bRow.duration;
      ELSEIF bRow.prev_row_create_date IS NOT NULL AND EXTRACT(epoch FROM((bRow.next_row_create_date - bRow.create_date)))::integer < 300 THEN
          bTempDuration = bTempDuration + bRow.duration;
      ELSE
        bTempBathroomUsageStart = bRow.prev_row_create_date - bTempDuration * INTERVAL '1 sec';
        IF bTempDuration > 30 THEN
          INSERT INTO bathroom_usage_intervals(bathroom_usage_start, bathroom_usage_end, bathroom_usage_interval) VALUES (bTempBathroomUsageStart, bRow.prev_row_create_date, bTempDuration);
        END IF;
        --refresh the duration
        bTempDuration = 0;
        bTempDuration = bTempDuration + bRow.duration;
      END IF;

    END LOOP;

    RETURN QUERY
      SELECT * FROM bathroom_usage_intervals;

END;
$BODY$
LANGUAGE plpgsql;