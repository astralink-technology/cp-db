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
    , user_away_eyecare_id varchar(32)
  )
AS
$BODY$
DECLARE
    pSleepingTime timestamp without time zone DEFAULT NULL;
    pAwayForTheNightId varchar(32) DEFAULT NULL;
    pDynamicSleepingStart timestamp without time zone;
    pDynamicActivityCount integer;
    pDynamicActivityCountTimeStart timestamp without time zone;
    pDynamicActivityCountTimeEnd timestamp without time zone;

    pDeploymentDate date;

    pLastEventTypeId varchar(64);
    pLastExtraData varchar(64);
    pLastEyeCareId varchar(32);
BEGIN
    -- Get the deployment date of the device
    SELECT
      d.deployment_date
    INTO
      pDeploymentDate
    FROM
      device d
    WHERE d.device_id = pDeviceId;

    -- check if user is away on that day
    SELECT
      e.eyecare_id
    INTO
      pAwayForTheNightId
    from (SELECT e.*,
                 lead(e.create_date) over (ORDER BY e.eyecare_id) AS next_create_date,
                 lead(e.event_type_id) over (ORDER BY e.eyecare_id) AS next_event_type_id
          from eyecare e
          WHERE e.create_date BETWEEN (pDay  || 'T' || '00:00')::timestamp AND ((pDay || 'T' || '23:59')::timestamp) AND
          ((pDeviceId = NULL) OR (e.device_id = pDeviceId)) AND (
            (e.node_name IN ('Door sensor', 'door sensor')  AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
            (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
            (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
            (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
            )
         ) e WHERE
    e.event_type_id = '20001'
    AND e.zone IN ('Living room', 'Living room')
    AND e.extra_data = 'Alarm Off'
    AND e.next_create_date IS NULL
    AND (next_event_type_id IS NULL OR next_event_type_id IN ('20001'))
    AND (next_create_date > create_date + 0.5 * INTERVAL '1 hour' OR next_create_date IS NULL);

    -- If use is not away on that day, check is user is away since that day
    SELECT
      e.event_type_id
      , e.extra_data
      , e.eyecare_id
    INTO
      pLastEventTypeId
      , pLastExtraData
      , pLastEyeCareId
    FROM eyecare e WHERE e.create_date BETWEEN (pDeploymentDate || 'T' || '00:00')::timestamp AND ((pDay || 'T' || '23:59')::timestamp) AND
          ((e.device_id = pDeviceId)) AND (
            (e.node_name IN ('Door sensor', 'door sensor')  AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
            (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
            (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
            (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
            ) ORDER BY e.create_date DESC LIMIT 1;

    -- If the last event is door close, the user is away for more than a day
    IF pLastEventTypeId = '20001' AND pLastExtraData = 'Alarm Off' THEN
       pAwayForTheNightId  = pLastEyeCareId;
    END IF;
    
    -- create a temp table to get the data
    CREATE TEMP TABLE sleep_analytics_temp(
        sleeping_time timestamp without time zone
    );


    IF pAwayForTheNightId IS NULL THEN
          -- dynamic queries
          -- INITIATE SEARCH FOR SLEEPING TIME
          -- PLAN A 2 Hour Time frame
          pDynamicSleepingStart = (pDay  || 'T' || '23:00')::timestamp;
          LOOP
            IF (pDynamicSleepingStart > (pDay  || 'T' || '20:00')::timestamp) THEN
                SELECT e.create_date INTO
                  pSleepingTime
                FROM (
                  SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
                  FROM eyecare e
                  WHERE (
                   (e.node_name IN ('Door sensor', 'door sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                   (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                   (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                   (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
                   ) AND
                   e.create_date BETWEEN pDynamicSleepingStart AND ((pDay || 'T' || '05:00')::timestamp + INTERVAL '1 day') AND
                 ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
                  ORDER BY e.create_date ASC
                ) e
                WHERE e.next_create_date > e.create_date + 2 * INTERVAL '1 hour'
                LIMIT 1;

                -- IF sleeping time is found, exit else continue
                IF pSleepingTime IS NOT NULL THEN
                  EXIT;
                ELSE
                  pDynamicSleepingStart = pDynamicSleepingStart - 1 * INTERVAL '1 hour';
                END IF;
            ELSE
                -- EXIT PLAN A
                EXIT;
            END IF;
          END LOOP;

          -- PLAN B 1.5 Hour Time frame
          IF pSleepingTime IS NULL THEN
            pDynamicSleepingStart = (pDay  || 'T' || '23:00')::timestamp;
            LOOP
              IF (pDynamicSleepingStart > (pDay  || 'T' || '20:00')::timestamp) THEN
                  SELECT e.create_date INTO
                    pSleepingTime
                  FROM (
                    SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
                    FROM eyecare e
                    WHERE (
                     (e.node_name IN ('Door sensor', 'door sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
                     ) AND
                     e.create_date BETWEEN pDynamicSleepingStart AND ((pDay || 'T' || '05:00')::timestamp + INTERVAL '1 day') AND
                   ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
                    ORDER BY e.create_date ASC
                  ) e
                  WHERE e.next_create_date > e.create_date + 1.5 * INTERVAL '1 hour'
                  LIMIT 1;

                  -- IF sleeping time is found, exit else continue
                  IF pSleepingTime IS NOT NULL THEN
                    EXIT;
                  ELSE
                    pDynamicSleepingStart = pDynamicSleepingStart - 1 * INTERVAL '1 hour';
                  END IF;
              ELSE
                  -- EXIT PLAN B
                  EXIT;
              END IF;
            END LOOP;
          END IF;

          -- PLAN C 1 Hour Time frame
          IF pSleepingTime IS NULL THEN
            pDynamicSleepingStart = (pDay  || 'T' || '23:00')::timestamp;
            LOOP
              IF (pDynamicSleepingStart > (pDay  || 'T' || '20:00')::timestamp) THEN
                  SELECT e.create_date INTO
                    pSleepingTime
                  FROM (
                    SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
                    FROM eyecare e
                    WHERE (
                     (e.node_name IN ('Door sensor', 'door sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
                     ) AND
                     e.create_date BETWEEN pDynamicSleepingStart AND ((pDay || 'T' || '05:00')::timestamp + INTERVAL '1 day') AND
                   ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
                    ORDER BY e.create_date ASC
                  ) e
                  WHERE e.next_create_date > e.create_date + 1 * INTERVAL '1 hour'
                  LIMIT 1;

                  -- IF sleeping time is found, exit else continue
                  IF pSleepingTime IS NOT NULL THEN
                    EXIT;
                  ELSE
                    pDynamicSleepingStart = pDynamicSleepingStart - 1 * INTERVAL '1 hour';
                  END IF;
              ELSE
                  -- EXIT PLAN C
                  EXIT;
              END IF;
            END LOOP;
          END IF;

          -- PLAN D 0.5 Hour Time frame
          IF pSleepingTime IS NULL THEN
            pDynamicSleepingStart = (pDay  || 'T' || '23:00')::timestamp;
            LOOP
              IF (pDynamicSleepingStart > (pDay  || 'T' || '20:00')::timestamp) THEN
                  SELECT e.create_date INTO
                    pSleepingTime
                  FROM (
                    SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
                    FROM eyecare e
                    WHERE (
                     (e.node_name IN ('Door sensor', 'door sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
                     ) AND
                     e.create_date BETWEEN pDynamicSleepingStart AND ((pDay || 'T' || '05:00')::timestamp + INTERVAL '1 day') AND
                   ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
                    ORDER BY e.create_date ASC
                  ) e
                  WHERE e.next_create_date > e.create_date + 0.5 * INTERVAL '1 hour'
                  LIMIT 1;

                  -- IF sleeping time is found, exit else continue
                  IF pSleepingTime IS NOT NULL THEN
                    EXIT;
                  ELSE
                    pDynamicSleepingStart = pDynamicSleepingStart - 1 * INTERVAL '1 hour';
                  END IF;
              ELSE
                  -- EXIT PLAN D
                  EXIT;
              END IF;
            END LOOP;
          END IF;

          -- PLAN E Less than 10 activities, counting forward from 11 pm
          IF pSleepingTime IS NULL THEN
            pDynamicActivityCountTimeStart = ((pDay  || 'T' || '23:00')::timestamp);
            pDynamicActivityCountTimeEnd = ((pDay  || 'T' || '00:00')::timestamp + INTERVAL '1 day');

            LOOP
              IF (pDynamicActivityCountTimeStart < ((pDay  || 'T' || '03:00')::timestamp + INTERVAL '1 day')) THEN
                  -- count the number of activities within the first time frame
                  SELECT
                    COUNT(*)
                  INTO
                    pDynamicActivityCount
                  FROM (
                    SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
                    FROM eyecare e
                    WHERE (
                     (e.node_name IN ('Door sensor', 'door sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
                     ) AND
                     e.create_date BETWEEN pDynamicActivityCountTimeStart AND pDynamicActivityCountTimeEnd AND
                   ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
                    ORDER BY e.create_date ASC
                  ) e;

                  -- if there are activity less than 10, get the last activity of the block
                  IF pDynamicActivityCount <= 10 THEN
                    SELECT e.create_date INTO
                      pSleepingTime
                    FROM (
                      SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
                      FROM eyecare e
                      WHERE (
                       (e.node_name IN ('Door sensor', 'door sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                       (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                       (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                       (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
                       ) AND
                     e.create_date BETWEEN pDynamicActivityCountTimeStart AND pDynamicActivityCountTimeEnd AND
                     ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
                      ORDER BY e.create_date DESC
                    ) e
                    LIMIT 1;
                    IF pSleepingTime IS NULL THEN
                        pSleepingTime = pDynamicActivityCountTimeStart;
                    END IF;
                  END IF;


                  -- IF sleeping time is found, exit else continue
                  IF pSleepingTime IS NOT NULL THEN
                    EXIT;
                  ELSE
                    pDynamicActivityCountTimeStart = pDynamicActivityCountTimeStart + 1 * INTERVAL '1 hour';
                    pDynamicActivityCountTimeEnd = pDynamicActivityCountTimeEnd + 1 * INTERVAL '1 hour';
                  END IF;
              ELSE
                  -- EXIT PLAN F
                  EXIT;
              END IF;
            END LOOP;
          END IF;

          -- PLAN F 0.25 Hour Time frame
          IF pSleepingTime IS NULL THEN
            pDynamicSleepingStart = (pDay  || 'T' || '23:00')::timestamp;
            LOOP
              IF (pDynamicSleepingStart > (pDay  || 'T' || '20:00')::timestamp) THEN
                  SELECT e.create_date INTO
                    pSleepingTime
                  FROM (
                    SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
                    FROM eyecare e
                    WHERE (
                     (e.node_name IN ('Door sensor', 'door sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
                     (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
                     ) AND
                     e.create_date BETWEEN pDynamicSleepingStart AND ((pDay || 'T' || '05:00')::timestamp + INTERVAL '1 day') AND
                   ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
                    ORDER BY e.create_date ASC
                  ) e
                  WHERE e.next_create_date > e.create_date + 0.25 * INTERVAL '1 hour'
                  LIMIT 1;

                  -- IF sleeping time is found, exit else continue
                  IF pSleepingTime IS NOT NULL THEN
                    EXIT;
                  ELSE
                    pDynamicSleepingStart = pDynamicSleepingStart - 1 * INTERVAL '1 hour';
                  END IF;
              ELSE
                  -- EXIT PLAN F
                  EXIT;
              END IF;
            END LOOP;
          END IF;

          -- FINAL CUT
          IF pSleepingTime IS NULL THEN
                INSERT INTO sleep_analytics_temp (sleeping_time)
                  SELECT
                    NULL AS sleeping_time;
          ELSE
                INSERT INTO sleep_analytics_temp (sleeping_time)
                  SELECT
                    pSleepingTime;
          END IF;

    ELSE
          INSERT INTO sleep_analytics_temp (sleeping_time)
            SELECT
              NULL AS sleeping_time;
    END IF;

    RETURN QUERY
      SELECT
        *
        , pDay
        , pDeviceId
        , pAwayForTheNightId as user_away_eyecare_id
      FROM sleep_analytics_temp;


    DROP TABLE sleep_analytics_temp;
END;
$BODY$
LANGUAGE plpgsql;
