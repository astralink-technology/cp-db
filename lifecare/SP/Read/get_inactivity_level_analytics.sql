-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_inactivity_level_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_inactivity_level_analytics(
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
)
AS
$BODY$
DECLARE
  aRow record;
BEGIN

  CREATE TEMP TABLE away_start_end_timings_init(
      away_timing timestamp without time zone
  );

  CREATE TEMP TABLE away_timings_init AS
    SELECT * FROM get_away_analytics(pDeviceId, pDay);

  FOR aRow IN SELECT * FROM away_timings_init LOOP
    IF aRow.away_start IS NOT NULL THEN
      INSERT INTO away_start_end_timings_init VALUES (aRow.away_start);
    END IF;

    IF aRow.away_end IS NOT NULL THEN
      INSERT INTO away_start_end_timings_init VALUES (aRow.away_end);
    END IF;
  END LOOP;

  CREATE TEMP TABLE inactivity_level_init AS
    SELECT
      ee.*
     FROM(
        SELECT
          e.eyecare_id
          , EXTRACT (EPOCH FROM e.create_date - (lag(e.create_date) over (ORDER BY e.eyecare_id)))::integer AS inactivity_duration
          , lead(e.create_date)  over (ORDER BY e.eyecare_id) AS next_row_create_date
          , lag(e.create_date)  over (ORDER BY e.eyecare_id) AS prev_row_create_date
          , e.create_date
          FROM eyecare e WHERE e.device_id = pDeviceId AND
          e.create_date BETWEEN (pDay || ' ' ||  '00:00:00')::timestamp AND (pDay || ' ' || '23:59:59')::timestamp AND((
                (e.node_name IN ('Door sensor', 'door sensor')  AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom')) OR -- Get only the sensor off in the bathroom
                (e.event_type_id IN ('20013')) -- Get BP HR Reading
                 ))ee
    WHERE ee.inactivity_duration > 299 AND
    ee.create_date NOT IN (SELECT * FROM away_start_end_timings_init) AND
    ee.next_row_create_date NOT IN (SELECT * FROM away_start_end_timings_init) AND
    ee.prev_row_create_date NOT IN (SELECT * FROM away_start_end_timings_init); -- more than 5 minutes to conside inactive

    RETURN QUERY
      SELECT
        *
      FROM inactivity_level_init;

    DROP TABLE inactivity_level_init;
    DROP TABLE away_start_end_timings_init;
    DROP TABLE away_timings_init;
END;
$BODY$
LANGUAGE plpgsql;
