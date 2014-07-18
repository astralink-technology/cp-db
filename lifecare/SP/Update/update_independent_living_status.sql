-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_independent_living_status' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_independent_living_status(
      pDeviceId varchar(32)
)
RETURNS TABLE(
    status char(1)
    , location_name varchar(128)
  )
AS
$BODY$
DECLARE
    pMedianWakeupTime timestamp without time zone;
    pMedianSleepingTime timestamp without time zone;

    pEyecareId varchar(32);
    pEventTypeName varchar(64);
    pEventTypeId varchar(64);
    pExtraData varchar(64);
    pZone varchar(64);
    pMotionDetectedDateTime timestamp without time zone;
    pEntityId varchar(32);

    pUserStatus char(1) DEFAULT NULL;
    pUserCurrentStatus char(1);
    pUserLastLocation varchar(128);

    pDurationSinceMotionDetect integer;
BEGIN

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
      , pEntityId
      , pExtraData
      , pUserCurrentStatus
    FROM eyecare e INNER JOIN entity en ON e.entity_id = en.entity_id WHERE (
     (
           (e.node_name IN ('Door sensor', 'door sensor') AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
           (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
           (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
           (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
     ) AND e.device_id = pDeviceId)
    ORDER BY create_date DESC LIMIT 1;

    -- Get the median wake up time of the user
    SELECT
      i.date_value2
    INTO
      pMedianWakeupTime
    FROM informative_analytics i
    WHERE i.owner_id = pDeviceId AND
    type = 'MW';

    -- Get the median sleeping time of the user
    SELECT
      i.date_value2
    INTO
      pMedianSleepingTime
    FROM informative_analytics i
    WHERE i.owner_id = pDeviceId AND
    type = 'MS';

    -- Set the user's last location
    pUserLastLocation = pZone;

    -- get the motion detected datetime difference with now
    SELECT
      EXTRACT(epoch FROM((NOW()::timestamp - pMotionDetectedDateTime)))::integer
    INTO
      pDurationSinceMotionDetect;

    -- Do the calculation
    IF (pEventTypeId = '20004' OR pEventTypeId = '20003' OR pEventTypeId = '20002') THEN
      -- Motion detected and the timing is less that 5 minutes, user is active else inactive
      IF (((pDurationSinceMotionDetect)::integer  / 60) < 5) THEN
        pUserStatus = 'A';
      ELSE
        pUserStatus = 'I';
      END IF;
    ELSEIF (pEventTypeId = '20001' AND pExtraData = 'Alarm Off') THEN
      -- Door close activity, user is likely to be away
      IF (((pDurationSinceMotionDetect)::integer  / 60) < 30) THEN
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

    -- Update the user status and the user's last location
    UPDATE entity SET
        status = pUserStatus
        , location_name = pUserLastLocation
        , last_update = pMotionDetectedDateTime
    WHERE entity_id = pEntityId;


    -- create temp table to return user statuses
    CREATE TEMP TABLE user_status_init(
        status char(1),
        location_name varchar(128)
    );

    INSERT INTO user_status_init VALUES (pUserStatus, pUserLastLocation);

    RETURN QUERY
      SELECT * FROM user_status_init;

END;
$BODY$
LANGUAGE plpgsql;