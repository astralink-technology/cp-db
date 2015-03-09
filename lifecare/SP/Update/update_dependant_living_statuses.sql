-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_dependant_living_statuses' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_dependant_living_statuses(
      pEntityId varchar(32)
)
RETURNS TABLE(
    entity_id varchar(32)
    , status char(1)
    , location_name varchar(64)
  ) AS
$BODY$
DECLARE
    pUserRow record;

    pAuthorizationLevel integer;
    pMedianWakeupTime timestamp without time zone;
    pMedianSleepingTime timestamp without time zone;

    pEyecareId varchar(32);
    pEventTypeName varchar(64);
    pEventTypeId varchar(64);
    pExtraData text;
    pZone varchar(64);
    pMotionDetectedDateTime timestamp without time zone;
    pDependantEntityId varchar(32);
    pDependantDeviceId varchar(32);

    pUserStatus char(1) DEFAULT NULL;
    pUserCurrentStatus char(1);
    pUserLastLocation varchar(128);

    pDurationSinceMotionDetect integer;

    pAuthorized bool;
BEGIN
    -- Get authorization level
    SELECT
      a.authorization_level
    INTO
      pAuthorizationLevel
    FROM authentication a INNER JOIN entity et ON et.authentication_id = a.authentication_id
    WHERE et.entity_id = pEntityId;


    CREATE TEMP TABLE dependants_init(
        entity_id varchar(32)
    );

    IF pAuthorizationLevel = 500 THEN

      -- Get all the entity that is connected to a device
      pAuthorized = true;
      INSERT INTO dependants_init (entity_id)
      SELECT
        dr.owner_id
      FROM device_relationship dr
        INNER JOIN device d ON dr.device_id = d.device_id
      WHERE d.type = 'L';

    ELSEIF pAuthorizationLevel = 400 THEN

      -- Get all the entity related to you
      pAuthorized = true;
      INSERT INTO dependants_init (entity_id)
      SELECT
        er.related_id
      FROM entity_relationship er
        INNER JOIN device_relationship dr ON dr.owner_id = er.related_id
        INNER JOIN device d ON d.device_id = dr.device_id
      WHERE er.entity_id = pEntityId
      AND d.type = 'L';

    ELSE

      pAuthorized = false;

    END IF;

    CREATE TEMP TABLE dependant_status_init(
        entity_id varchar(32),
        status  char(1),
        location_name varchar(128)
    );

    IF pAuthorized = true THEN

      FOR pUserRow IN SELECT * FROM dependants_init LOOP
        pDependantEntityId = pUserRow.entity_id;
        -- Get the dependant's deviceId
        SELECT
          dr.device_id
        INTO
          pDependantDeviceId
        FROM device_relationship dr
          INNER JOIN device d ON d.device_id = dr.device_id
        WHERE dr.owner_id = pDependantEntityId AND d.type = 'L';

        -- Get the last activity of the user and insert them into the variables
            SELECT
              e.eyecare_id
              , e.event_type_name
              , e.event_type_id
              , e.zone
              , e.create_date
              , e.entity_id
              , e.extra_data
              , en.status
            INTO
              pEyecareId
              , pEventTypeName
              , pEventTypeId
              , pZone
              , pMotionDetectedDateTime
              , pDependantEntityId
              , pExtraData
              , pUserCurrentStatus
            FROM eyecare e INNER JOIN entity en ON e.entity_id = en.entity_id WHERE (
           (
                 (e.event_type_id = '20001' AND ((e.zone IN ('Living Room', 'Living room')) OR e.node_name IN ('Door sensor', 'door sensor') OR e.zone_code = 'LR') AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                 (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone IN ('Living Room', 'Living room')) OR e.zone_code = 'LR')) OR -- Door Opening and Closing
                 (e.event_type_id IN ('20004') AND e.node_id = '4' AND ((e.zone IN ('Living Room', 'Living room')) OR e.zone_code = 'LR')) OR -- Living room motion detected
                 (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone = 'Master Bedroom') OR e.zone_code = 'MR')) OR -- Bedroom motion sensor alarm on
                 (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone = 'Kitchen') OR e.zone_code = 'KI')) OR -- Kitchen  motion sensor alarm on
                 (e.event_type_id IN ('20002', '20003', '20005') AND ((e.zone = 'Bathroom') OR e.zone_code = 'BT1')) -- Get only the sensor off in the bathroom
           ) AND e.device_id = pDeviceId)
            ORDER BY create_date DESC LIMIT 1;

            -- Get the median wake up time of the user
            SELECT
              i.date_value2
            INTO
              pMedianWakeupTime
            FROM informative_analytics i
            WHERE i.owner_id = pDependantDeviceId AND
            type = 'MW';

            -- Get the median sleeping time of the user
            SELECT
              i.date_value2
            INTO
              pMedianSleepingTime
            FROM informative_analytics i
            WHERE i.owner_id = pDependantDeviceId AND
            type = 'MS';

            -- Set the user's last location
            pUserLastLocation = pZone;

            -- get the motion detected datetime difference with now
            SELECT
              EXTRACT ('epoch' FROM (NOW()::timestamp - pMotionDetectedDateTime)::interval)::integer
            INTO
              pDurationSinceMotionDetect;

            -- Do the calculation
            IF (pEventTypeId = '20004' OR pEventTypeId = '20003' OR pEventTypeId = '20002' OR pEventTypeId = '20005' OR (pEventTypeId = '20001' AND pExtraData = 'Alarm On')) THEN
              -- Motion detected and the timing is less that 5 minutes, user is active else inactive
              IF (pDurationSinceMotionDetect < 540) THEN
                pUserStatus = 'A';
              ELSE
                pUserStatus = 'I';
              END IF;
            ELSEIF (pEventTypeId = '20001' AND pExtraData = 'Alarm Off') THEN
              -- Door close activity, user is likely to be away
              IF (pDurationSinceMotionDetect  < 2040) THEN
                IF (pUserCurrentStatus != 'W') THEN
                  pUserStatus = 'L';
                ELSE
                  pUserStatus = 'W';
                END IF;
              ELSE
                -- Door close activity more than 30 minutes, user is away
                pUserStatus = 'W';
              END IF;
            END IF;

            IF pDependantEntityId IS NOT NULL THEN
              -- Update the user status and the user's last location
              UPDATE
                  entity ee
              SET
                  status = pUserStatus
                  , location_name = pUserLastLocation
                  , last_update = pMotionDetectedDateTime
              WHERE
                  ee.entity_id = pDependantEntityId;
            END IF;

            -- Insert into the table
            INSERT INTO dependant_status_init VALUES (pDependantEntityId, pUserStatus, pUserLastLocation);
      END LOOP;
    END IF;

    RETURN QUERY
      SELECT * FROM dependant_status_init;
END;
$BODY$
LANGUAGE plpgsql;