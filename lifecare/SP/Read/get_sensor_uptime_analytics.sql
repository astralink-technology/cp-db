-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_sensor_uptime_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_sensor_uptime_analytics(
        pDeviceId varchar(32)
        , pDay date
        , pZoneCode varchar(32)
    )
RETURNS TABLE(
    -- activity_level integer
    battery_analytics_type varchar(32)
    , battery_status char(1)
    , analytics_date timestamp without time zone
    , last_update timestamp without time zone
    , last_update_duration integer
    , zone_code varchar(32)
    , zone varchar(64)
    , node_name varchar(64)
  )
AS
$BODY$
DECLARE
  zRow record;

  oBatteryAnalyticsType varchar(32);
  oBatteryStatus char(1);

  oUpdateCount integer;
  oLastUpdateDateTime timestamp without time zone;
  oLastUpdatedDuration integer;
  oZone varchar(64);
  oNodeName varchar(64);
BEGIN

  CREATE TEMP TABLE IF NOT EXISTS battery_status_temp(
    battery_analytics_type varchar(32)
    , battery_status char(1)
    , analytics_date timestamp without time zone
    , last_update timestamp without time zone
    , last_update_duration integer
    , zone_code varchar(32)
    , zone varchar(64)
    , node_name varchar(64)
  ) ON COMMIT DROP;
  -- clear the table
  DELETE FROM battery_status_temp;

  CREATE TEMP TABLE IF NOT EXISTS zone_code_temp(
    zone_code varchar(32)
  ) ON COMMIT DROP;
  -- clear the table
  DELETE FROM zone_code_temp;

  -- If the date is passed in, the analytics will be for the day. If there are no dates passed in, the analytics will be current
  -- Date is passed in, the status is day specific
    IF pDay IS NOT NULL AND pDay != CURRENT_DATE THEN
      oBatteryAnalyticsType = 'Day Specific Status';
      IF pZoneCode IS NOT NULL THEN
        -- get only for the particular zone
        -- get the last row.
        SELECT
          e.create_date
          , e.node_name
          , e.zone
        INTO
          oLastUpdateDateTime
          , oNodeName
          , oZone
        FROM eyecare e WHERE
          e.event_type_id IN ('20010', '20001') AND
          e.create_date BETWEEN (pDay || ' ' || '00:00')::timestamp AND (pDay || ' ' || '23:59')::timestamp AND
          e.device_id = pDeviceId AND
          e.zone_code = pZoneCode
        ORDER BY e.create_date DESC
        LIMIT 1;

        -- count the number of updates
        SELECT
          COUNT(e.*)
        INTO
          oUpdateCount
        FROM eyecare e WHERE
          e.event_type_id IN ('20010', '20001') AND
          e.create_date BETWEEN (pDay || ' ' || '00:00')::timestamp AND (pDay || ' ' || '23:59')::timestamp AND
          e.device_id = pDeviceId AND
          e.zone_code = pZoneCode;

        oLastUpdatedDuration = EXTRACT (EPOCH FROM ((pDay || ' ' || '23:59')::timestamp - oLastUpdateDateTime))::integer / 60;
        IF oUpdateCount < 5 OR oLastUpdatedDuration > 400 THEN
            -- particular sensor is down
            oBatteryStatus = 'I';
        ELSE
            oBatteryStatus = 'A';
        END IF;

        INSERT INTO battery_status_temp VALUES(
          oBatteryAnalyticsType
          , oBatteryStatus
          , pDay
          , oLastUpdateDateTime
          , oLastUpdatedDuration
          , pZoneCode
          , oZone
          , oNodeName
        );
      ELSE
        -- get only for every zone
        INSERT INTO zone_code_temp (zone_code)
          SELECT DISTINCT(e.zone_code) FROM e.eyecare WHERE e.device_id = pDeviceId AND e.zone_code IS NOT NULL AND e.zone_code != '';

        FOR zRow IN SELECT * FROM zone_code_temp LOOP
          -- get only for the particular zone
          -- get the last row.
          SELECT
            e.create_date
            , e.node_name
            , e.zone
          INTO
            oLastUpdateDateTime
            , oNodeName
            , oZone
          FROM eyecare e WHERE
            e.event_type_id IN ('20010', '20001') AND
            e.create_date BETWEEN (pDay || ' ' || '00:00')::timestamp AND (pDay || ' ' || '23:59')::timestamp AND
            e.device_id = pDeviceId AND
            e.zone_code = zRow.zone_code
          ORDER BY e.create_date DESC
          LIMIT 1;

          -- count the number of updates
          SELECT
            COUNT(e.*)
          INTO
            oUpdateCount
          FROM eyecare e WHERE
            e.event_type_id IN ('20010', '20001') AND
            e.create_date BETWEEN (pDay || ' ' || '00:00')::timestamp AND (pDay || ' ' || '23:59')::timestamp AND
            e.device_id = pDeviceId AND
            e.zone_code = zRow.zone_code;

          oLastUpdatedDuration = EXTRACT (EPOCH FROM ((pDay || ' ' || '23:59')::timestamp - oLastUpdateDateTime))::integer / 60;
          IF oUpdateCount < 5 OR oLastUpdatedDuration > 400 THEN
              -- particular sensor is down
              oBatteryStatus = 'I';
          ELSE
              oBatteryStatus = 'A';
          END IF;

          INSERT INTO battery_status_temp VALUES(
            oBatteryAnalyticsType
            , oBatteryStatus
            , pDay
            , oLastUpdateDateTime
            , oLastUpdatedDuration
            , zRow.zone_code
            , oZone
            , oNodeName
          );
        END LOOP;

      END IF;
  ELSE
    oBatteryAnalyticsType = 'Current Status';
    IF pZoneCode IS NOT NULL THEN
          -- get only for the particular zone
          -- get the last row.
          SELECT
            e.create_date
            , e.node_name
            , e.zone
          INTO
            oLastUpdateDateTime
            , oNodeName
            , oZone
          FROM eyecare e WHERE
            e.event_type_id IN ('20010', '20001') AND
            e.device_id = pDeviceId AND
            e.zone_code = pZoneCode
          ORDER BY e.create_date DESC
          LIMIT 1;

          -- count the number of updates
          SELECT
            COUNT(e.*)
          INTO
            oUpdateCount
          FROM eyecare e WHERE
            e.event_type_id IN ('20010', '20001') AND
            e.device_id = pDeviceId AND
            e.zone_code = pZoneCode;

          oLastUpdatedDuration = EXTRACT (EPOCH FROM (NOW() - oLastUpdateDateTime))::integer / 60;
          IF oUpdateCount < 5 OR oLastUpdatedDuration > 400 THEN
              -- particular sensor is down
              oBatteryStatus = 'I';
          ELSE
              oBatteryStatus = 'A';
          END IF;

          INSERT INTO battery_status_temp VALUES(
            oBatteryAnalyticsType
            , oBatteryStatus
            , pDay
            , oLastUpdateDateTime
            , oLastUpdatedDuration
            , pZoneCode
            , oZone
            , oNodeName
          );
    ELSE
      -- get only for every zone
      INSERT INTO zone_code_temp(zone_code)
        SELECT DISTINCT(e.zone_code) FROM eyecare e WHERE e.device_id = pDeviceId AND e.zone_code IS NOT NULL AND e.zone_code != '';

      FOR zRow IN SELECT * FROM zone_code_temp LOOP
          -- get only for the particular zone
          -- get the last row.
          SELECT
            e.create_date
            , e.node_name
            , e.zone
          INTO
            oLastUpdateDateTime
            , oNodeName
            , oZone
          FROM eyecare e WHERE
            e.event_type_id IN ('20010', '20001') AND
            e.device_id = pDeviceId AND
            e.zone_code = zRow.zone_code
          ORDER BY e.create_date DESC
          LIMIT 1;

          -- count the number of updates
          SELECT
            COUNT(e.*)
          INTO
            oUpdateCount
          FROM eyecare e WHERE
            e.event_type_id IN ('20010', '20001') AND
            e.device_id = pDeviceId AND
            e.zone_code = zRow.zone_code;

          oLastUpdatedDuration = EXTRACT (EPOCH FROM (NOW() - oLastUpdateDateTime))::integer / 60;
          IF oUpdateCount < 5 OR oLastUpdatedDuration > 400 THEN
              -- particular sensor is down
              oBatteryStatus = 'I';
          ELSE
              oBatteryStatus = 'A';
          END IF;

          INSERT INTO battery_status_temp VALUES(
            oBatteryAnalyticsType
            , oBatteryStatus
            , pDay
            , oLastUpdateDateTime
            , oLastUpdatedDuration
            , zRow.zone_code
            , oZone
            , oNodeName
          );
      END LOOP;

    END IF;
  END IF;

  RETURN QUERY
    SELECT
      *
    FROM battery_status_temp;
END;
$BODY$
LANGUAGE plpgsql;
