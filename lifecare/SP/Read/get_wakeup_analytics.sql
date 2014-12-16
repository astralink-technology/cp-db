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
    , slept_date_time timestamp without time zone
  )
  AS
  $BODY$
  DECLARE
      pDynamicActivityCount integer;
      pDynamicActivityCountTimeStart timestamp without time zone;
      pDynamicActivityCountTimeEnd timestamp without time zone;
      pWakeupTime timestamp without time zone DEFAULT NULL;

      pSleptDateTime timestamp without time zone DEFAULT NULL;
  BEGIN

    -- check if user has slept for the night on that day
    SELECT
      date_value2
    INTO
      pSleptDateTime
    FROM analytics_value WHERE
    type = 'S' AND owner_id = pDeviceId AND date_value = ((pDay || 'T' || '00:00:00')::timestamp - INTERVAL '1 day');

    CREATE TEMP TABLE wakeup_analytics_temp(
        wakeup_date_time timestamp without time zone
    );

    -- if user slept that night, we generate the id
    IF pSleptDateTime IS NOT NULL THEN
        -- PLAN A Sampling Size 20
        IF pWakeupTime IS NULL THEN
          pDynamicActivityCountTimeStart = (pDay  || 'T' || '05:00')::timestamp;
          pDynamicActivityCountTimeEnd = (pDay  || 'T' || '06:00')::timestamp;

          LOOP
            IF (pDynamicActivityCountTimeEnd < (pDay  || 'T' || '11:01')::timestamp) THEN
                -- count the number of activities within the first time frame
                SELECT
                  COUNT(*)
                INTO
                  pDynamicActivityCount
                FROM eyecare e WHERE(
                   (e.node_name IN ('Door sensor', 'door sensor', 'Door Sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                   (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                   (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                   (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') OR -- Get only the sensor off in the bathroom
                (e.event_type_id IN ('20013')) -- Get BP HR Reading
                   ) AND
                ((pDay IS NULL) OR (e.create_date BETWEEN pDynamicActivityCountTimeStart AND pDynamicActivityCountTimeEnd)) AND
                ((pDeviceId IS NULL) OR (e.device_id = pDeviceId));

                -- if there are activity more than 120, get the last activity of the block
                IF pDynamicActivityCount >= 20 THEN
                  SELECT e.create_date INTO
                    pWakeupTime
                  FROM (
                    SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
                    FROM eyecare e
                    WHERE (
                     (e.node_name IN ('Door sensor', 'door sensor', 'Door Sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') OR -- Get only the sensor off in the bathroom
                (e.event_type_id IN ('20013')) -- Get BP HR Reading
                     ) AND
                   e.create_date BETWEEN pDynamicActivityCountTimeStart AND pDynamicActivityCountTimeEnd AND
                   ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
                    ORDER BY e.create_date DESC
                  ) e
                  LIMIT 1 OFFSET 19;
                END IF;


                -- IF wakeup time is found, exit else continue
                IF pWakeupTime IS NOT NULL THEN
                  EXIT;
                ELSE
                  pDynamicActivityCountTimeStart = pDynamicActivityCountTimeStart + 1 * INTERVAL '1 hour';
                  pDynamicActivityCountTimeEnd = pDynamicActivityCountTimeEnd + 1 * INTERVAL '1 hour';
                END IF;
            ELSE
                -- EXIT PLAN A
                EXIT;
            END IF;
          END LOOP;
        END IF;

        -- PLAN B Sampling Size 15
        IF pWakeupTime IS NULL THEN
          pDynamicActivityCountTimeStart = ((pDay  || 'T' || '05:00')::timestamp);
          pDynamicActivityCountTimeEnd = ((pDay  || 'T' || '06:00')::timestamp);

          LOOP
            IF (pDynamicActivityCountTimeEnd < (pDay  || 'T' || '11:01')::timestamp) THEN
                -- count the number of activities within the first time frame
                SELECT
                  COUNT(*)
                INTO
                  pDynamicActivityCount
                FROM eyecare e WHERE(
                   (e.node_name IN ('Door sensor', 'door sensor', 'Door Sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                   (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                   (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                   (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') OR -- Get only the sensor off in the bathroom
                (e.event_type_id IN ('20013')) -- Get BP HR Reading
                   ) AND
                ((pDay IS NULL) OR (e.create_date BETWEEN pDynamicActivityCountTimeStart AND pDynamicActivityCountTimeEnd)) AND
                ((pDeviceId IS NULL) OR (e.device_id = pDeviceId));

                -- if there are activity more than 15, get the last activity of the block
                IF pDynamicActivityCount >= 15 THEN
                  SELECT e.create_date INTO
                    pWakeupTime
                  FROM (
                    SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
                    FROM eyecare e
                    WHERE (
                     (e.node_name IN ('Door sensor', 'door sensor', 'Door Sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') OR -- Get only the sensor off in the bathroom
                (e.event_type_id IN ('20013')) -- Get BP HR Reading
                     ) AND
                   e.create_date BETWEEN pDynamicActivityCountTimeStart AND pDynamicActivityCountTimeEnd AND
                   ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
                    ORDER BY e.create_date DESC
                  ) e
                  LIMIT 1 OFFSET 14;
                END IF;


                -- IF wakeup time is found, exit else continue
                IF pWakeupTime IS NOT NULL THEN
                  EXIT;
                ELSE
                  pDynamicActivityCountTimeStart = pDynamicActivityCountTimeStart + 1 * INTERVAL '1 hour';
                  pDynamicActivityCountTimeEnd = pDynamicActivityCountTimeEnd + 1 * INTERVAL '1 hour';
                END IF;
            ELSE
                -- EXIT PLAN A
                EXIT;
            END IF;
          END LOOP;
        END IF;

        -- PLAN C Sampling Size 10
        IF pWakeupTime IS NULL THEN
          pDynamicActivityCountTimeStart = ((pDay  || 'T' || '05:00')::timestamp);
          pDynamicActivityCountTimeEnd = ((pDay  || 'T' || '06:00')::timestamp);

          LOOP
            IF (pDynamicActivityCountTimeEnd < (pDay  || 'T' || '11:01')::timestamp) THEN
                -- count the number of activities within the first time frame
                SELECT
                  COUNT(*)
                INTO
                  pDynamicActivityCount
                FROM eyecare e WHERE(
                   (e.node_name IN ('Door sensor', 'door sensor', 'Door Sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                   (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                   (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                   (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') OR -- Get only the sensor off in the bathroom
                (e.event_type_id IN ('20013')) -- Get BP HR Reading
                   ) AND
                ((pDay IS NULL) OR (e.create_date BETWEEN pDynamicActivityCountTimeStart AND pDynamicActivityCountTimeEnd)) AND
                ((pDeviceId IS NULL) OR (e.device_id = pDeviceId));

                -- if there are activity more than 10, get the last activity of the block
                IF pDynamicActivityCount >= 10 THEN
                  SELECT e.create_date INTO
                    pWakeupTime
                  FROM (
                    SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
                    FROM eyecare e
                    WHERE (
                     (e.node_name IN ('Door sensor', 'door sensor', 'Door Sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') OR -- Get only the sensor off in the bathroom
                (e.event_type_id IN ('20013')) -- Get BP HR Reading
                     ) AND
                   e.create_date BETWEEN pDynamicActivityCountTimeStart AND pDynamicActivityCountTimeEnd AND
                   ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
                    ORDER BY e.create_date DESC
                  ) e
                  LIMIT 1 OFFSET 9;
                END IF;


                -- IF wakeup time is found, exit else continue
                IF pWakeupTime IS NOT NULL THEN
                  EXIT;
                ELSE
                  pDynamicActivityCountTimeStart = pDynamicActivityCountTimeStart + 1 * INTERVAL '1 hour';
                  pDynamicActivityCountTimeEnd = pDynamicActivityCountTimeEnd + 1 * INTERVAL '1 hour';
                END IF;
            ELSE
                -- EXIT PLAN A
                EXIT;
            END IF;
          END LOOP;
        END IF;

        -- PLAN D Sampling Size 5
        IF pWakeupTime IS NULL THEN
          pDynamicActivityCountTimeStart = ((pDay  || 'T' || '05:00')::timestamp);
          pDynamicActivityCountTimeEnd = ((pDay  || 'T' || '06:00')::timestamp);

          LOOP
            IF (pDynamicActivityCountTimeEnd < (pDay  || 'T' || '11:01')::timestamp) THEN
                -- count the number of activities within the first time frame
                SELECT
                  COUNT(*)
                INTO
                  pDynamicActivityCount
                FROM eyecare e WHERE(
                   (e.node_name IN ('Door sensor', 'door sensor', 'Door Sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                   (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                   (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                   (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') OR -- Get only the sensor off in the bathroom
                (e.event_type_id IN ('20013')) -- Get BP HR Reading
                   ) AND
                ((pDay IS NULL) OR (e.create_date BETWEEN pDynamicActivityCountTimeStart AND pDynamicActivityCountTimeEnd)) AND
                ((pDeviceId IS NULL) OR (e.device_id = pDeviceId));

                -- if there are activity more than 5, get the last activity of the block
                IF pDynamicActivityCount >= 5 THEN
                  SELECT e.create_date INTO
                    pWakeupTime
                  FROM (
                    SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
                    FROM eyecare e
                    WHERE (
                     (e.node_name IN ('Door sensor', 'door sensor', 'Door Sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') OR -- Get only the sensor off in the bathroom
                (e.event_type_id IN ('20013')) -- Get BP HR Reading
                     ) AND
                   e.create_date BETWEEN pDynamicActivityCountTimeStart AND pDynamicActivityCountTimeEnd AND
                   ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
                    ORDER BY e.create_date DESC
                  ) e
                  LIMIT 1 OFFSET 4;
                END IF;


                -- IF wakeup time is found, exit else continue
                IF pWakeupTime IS NOT NULL THEN
                  EXIT;
                ELSE
                  pDynamicActivityCountTimeStart = pDynamicActivityCountTimeStart + 1 * INTERVAL '1 hour';
                  pDynamicActivityCountTimeEnd = pDynamicActivityCountTimeEnd + 1 * INTERVAL '1 hour';
                END IF;
            ELSE
                -- EXIT PLAN A
                EXIT;
            END IF;
          END LOOP;
        END IF;

          -- FINAL CUT
          IF pWakeupTime IS NULL THEN
              INSERT INTO wakeup_analytics_temp (wakeup_date_time)
                SELECT
                  NULL AS wakeup_date_time;
          ELSE
              INSERT INTO wakeup_analytics_temp (wakeup_date_time)
                  SELECT
                    pWakeupTime;
          END IF;
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
        , pSleptDateTime as slept_date_time
      FROM wakeup_analytics_temp;


    DROP TABLE wakeup_analytics_temp;
  END;
  $BODY$
  LANGUAGE plpgsql;
