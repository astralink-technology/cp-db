  -- Drop function
  DO $$
  DECLARE fname text;
  BEGIN
  FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_wakeup_analytics' LOOP
    EXECUTE 'DROP FUNCTION ' || fname;
  END loop;
  RAISE INFO 'FUNCTION % DROPPED', fname;
  END$$;
  -- Start function
  CREATE FUNCTION get_wakeup_analytics(
          pDeviceId varchar(32)
          , pDay date
      )
  RETURNS TABLE(
    wakeup_date_time timestamp without time zone
    , analytics_date date
    , device_id varchar(32)
  )
  AS
  $BODY$
  DECLARE
      pSamplingSize integer;
      pSampleStartDateTime timestamp without time zone;
      pSampleEndDateTime timestamp without time zone;
      pSampleThresholdEndDateTime timestamp without time zone;
      pWakeupDateTime timestamp without time zone;
  BEGIN

      pSampleStartDateTime = (pDay || 'T' || '05:00:00')::timestamp;
      pSampleEndDateTime = (pDay || 'T' || '05:59:59')::timestamp;

      pSampleThresholdEndDateTime  = (pDay || 'T' || '10:59:59')::timestamp;

      pSamplingSize = 0;

      WHILE (pSampleEndDateTime < pSampleThresholdEndDateTime)
        LOOP
            IF pSamplingSize >= 10 THEN
            ELSE
              SELECT
                COUNT(*)
              INTO STRICT
               pSamplingSize
              FROM eyecare e WHERE(
                 (e.node_name = 'Door sensor' AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                 (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                 (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                 (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
                 ) AND
              ((pDay IS NULL) OR (e.create_date BETWEEN pSampleStartDateTime AND pSampleEndDateTime)) AND
              ((pDeviceId IS NULL) OR (e.device_id = pDeviceId));
            END IF;

            EXIT WHEN pSamplingSize >= 10;

            --increment
            pSampleStartDateTime = pSampleStartDateTime + INTERVAL '1 hour';
            pSampleEndDateTime = pSampleEndDateTime + INTERVAL '1 hour';

        END LOOP;


    CREATE TEMP TABLE wakeup_analytics_temp(
        wakeup_date_time timestamp without time zone
    );

    IF pSamplingSize >= 10 THEN
        INSERT INTO wakeup_analytics_temp (wakeup_date_time)
          SELECT
            e.create_date
          FROM eyecare e WHERE(
             (e.node_name = 'Door sensor' AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
             (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
             (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
             (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
             ) AND
          ((pDay IS NULL) OR (e.create_date BETWEEN pSampleStartDateTime AND pSampleEndDateTime)) AND
          ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
          ORDER BY e.eyecare_id ASC
          LIMIT 1 OFFSET 9;
    ELSE
        INSERT INTO wakeup_analytics_temp (wakeup_date_time)
          SELECT
            NULL AS wakeup_date_time;
    END IF;

      RETURN QUERY
        SELECT
          *
          , pDay
          , pDeviceId
        FROM wakeup_analytics_temp;

  END;
  $BODY$
  LANGUAGE plpgsql;
