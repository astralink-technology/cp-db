-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_individual_sensor_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_individual_sensor_details(
          pMainDeviceId varchar(32)
        )
RETURNS TABLE (
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
    sensorRow record;

    sensorCount integer;
    nSensorId varchar(32);
BEGIN

  -- delete all the devices which has the connected device id (select first just in case)
--   SELECT * FROM device WHERE device_id IN
--   (
--     SELECT connected_device_id FROM device_session WHERE device_id = pMainDeviceId
--   );
--
--   -- Create a temp table for returning
--   CREATE TEMP TABLE IF NOT EXISTS sensor_uptime_return(
--       battery_analytics_type varchar(32)
--       , battery_status char(1)
--       , analytics_date timestamp without time zone
--       , last_update timestamp without time zone
--       , last_update_duration integer
--       , zone_code varchar(32)
--       , zone varchar(64)
--       , node_name varchar(64)
--   ) ON COMMIT DROP;
--
--   DELETE FROM sensor_uptime_return;

  CREATE TEMP TABLE sensor_uptime_temp AS
      SELECT * FROM get_sensor_uptime_analytics(pMainDeviceId, null, null);

  SELECT COUNT(*) INTO sensorCount FROM sensor_uptime_temp;

  IF sensorCount > 0 THEN
    oAwayCount := 0;
    FOR sensorRow IN SELECT * FROM sensor_uptime_temp LOOP
      -- generate the ID
      SELECT generate_id INTO STRICT nSensorId FROM generate_id();

    battery_analytics_type varchar(32)
    , battery_status char(1)
    , analytics_date timestamp without time zone
    , last_update timestamp without time zone
    , last_update_duration integer
    , zone_code varchar(32)
    , zone varchar(64)
    , node_name varchar(64)

      -- get the day of the week of the away
      IF generate.away_start IS NOT NULL THEN
        SELECT EXTRACT(DOW FROM awayRow.away_start) INTO STRICT oDowForAwayStart;
      ELSE
        oDowForAwayStart := null;
      END IF;

      -- get the number of aways
      oAwayCount := oAwayCount + 1;

      -- Insert into the analytics_value
      INSERT INTO analytics_value (
          analytics_value_id
          , analytics_value_name
          , date_value
          , date_value2
          , date_value3
          , value
          , value2
          , int_value
          , int_value2
          , type
          , create_date
          , owner_id
      ) VALUES(
            nAnalyticsValueId
            , 'Away Mode'
            , (pDay  || 'T' || '00:00')::timestamp
            , awayRow.away_start
            , awayRow.away_end
            , null
            , null
            , oAwayCount
            , oDowForAwayStart
            , 'A'
            , (NOW() at time zone 'utc')::timestamp
            , pDeviceId
      );
      -- insert into the return table for the return data
      INSERT INTO analytics_value_return VALUES
        (
            nAnalyticsValueId
            , (pDay  || 'T' || '00:00')::timestamp
            , awayRow.away_start
            , awayRow.away_end
            , oAwayCount
            , oDowForAwayStart
            , tempDeviceId
        );
    END LOOP;
  ELSE
   -- generate the ID
   SELECT generate_id INTO STRICT nAnalyticsValueId FROM generate_id();
   INSERT INTO analytics_value (
        analytics_value_id
        , analytics_value_name
        , date_value
        , date_value2
        , date_value3
        , value
        , value2
        , int_value
        , int_value2
        , type
        , create_date
        , owner_id
      ) VALUES(
          nAnalyticsValueId
          , 'Away Mode'
          , (pDay  || 'T' || '00:00')::timestamp
          , null
          , null
          , null
          , null
          , null
          , null
          , 'A'
          , (NOW()  at time zone 'utc')::timestamp
          , pDeviceId
      );
      -- insert into the return table for the return data
      INSERT INTO analytics_value_return VALUES
        (
            nAnalyticsValueId
            , (pDay  || 'T' || '00:00')::timestamp
            , null
            , null
            , null
            , null
            , pDeviceId
        );
  END IF;

  DROP TABLE away_values_temp;

  RETURN QUERY
    SELECT
      *
    FROM sensor_uptime_temp;

END;
$BODY$
LANGUAGE plpgsql;