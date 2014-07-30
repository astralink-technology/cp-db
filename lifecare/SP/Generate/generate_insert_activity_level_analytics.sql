-- DEPRECATED
-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'generate_insert_activity_level_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION generate_insert_activity_level_analytics()
RETURNS TABLE (
    analytics_value_id varchar(32)
    , date_value timestamp without time zone
    , date_value2 timestamp without time zone
    , date_value3 timestamp without time zone
    , value varchar(32)
    , value2 varchar(32)
    , value3 varchar(32)
    , value4 varchar(32)
    , intValue integer
    , intValue2 integer
    , intValue3 integer
    , intValue4 integer
    , owner_id varchar(32)
)
AS
$BODY$
DECLARE
    uRow record;
    naRow record;

    tempDeploymentDate date;
    tempEntityId varchar(32);
    tempDeviceId varchar(32);

    tempWakeupTime timestamp without time zone default null;
    tempSleepingTime timestamp without time zone default null;
    tempDayDuration integer default null;
    tempNightDuration integer default null;
    tempDayAwayDuration integer default null;
    tempNightAwayDuration integer default null;
    tempDayActive integer default null;
    temNightActive integer default null;
    tempDayActivityLevel integer default null;
    tempNightActivityLevel integer default null;

    nAnalyticsValueId varchar(32);
BEGIN
  -- Create a temp table for returning
  CREATE TEMP TABLE IF NOT EXISTS analytics_value_return(
    analytics_value_id varchar(32)
    , date_value timestamp without time zone
    , date_value2 timestamp without time zone
    , date_value3 timestamp without time zone
    , value varchar(32)
    , value2 varchar(32)
    , value3 varchar(32)
    , value4 varchar(32)
    , intValue integer
    , intValue2 integer
    , intValue3 integer
    , intValue4 integer
    , owner_id varchar(32)
  ) ON COMMIT DROP;

  -- clear the table
  DELETE FROM analytics_value_return;

  -- Create a temp table to store all the days that has not been analyze
  CREATE TEMP TABLE non_analyzed_init(
      date_value timestamp without time zone
  ) ON COMMIT DROP;

  -- Get all users with valid
  CREATE TEMP TABLE IF NOT EXISTS user_away_init(
        owner_id varchar(32)
        , device_id varchar(32)
        , deployment_date date
        , type char(1)
  ) ON COMMIT DROP;
  -- clear the table
  DELETE FROM user_away_init;

  INSERT INTO user_away_init
  (
      owner_id
      , device_id
      , deployment_date
      , type
  )
    SELECT
      dr.owner_id
      , dr.device_id
      , d.deployment_date
      , d.type
    FROM device_relationship dr INNER JOIN device d ON d.device_id = dr.device_id WHERE d.type = 'L';

  -- loop through the users
--   FOR uRow IN SELECT * FROM user_away_init LOOP
--     tempDeploymentDate = uRow.deployment_date;
--     tempEntityId = uRow.owner_id;
--     tempDeviceId = uRow.device_id;

    -- get the dates that have not been analyzed
    INSERT INTO non_analyzed_init (date_value)
      SELECT dv as date_value FROM generate_series('2014-04-01'::timestamp, CURRENT_TIMESTAMP::timestamp, '1 day') as dv WHERE
      dv NOT IN (
        SELECT DISTINCT(av.date_value) FROM analytics_value av WHERE av.owner_id = 'z0a783989897' AND av.type = 'ACT'
      );

    FOR naRow IN SELECT * FROM non_analyzed_init LOOP
      -- For row that is not analyzed for the user, find the wake up time and do the insert
      SELECT
        wakeup_time
        , sleeping_time
        , day_duration
        , night_duration
        , day_away_duration
        , night_away_duration
        , day_active
        , night_active
        , day_activity_level
        , night_activity_level
      INTO
        tempWakeupTime
        , tempSleepingTime
        , tempDayDuration
        , tempNightDuration
        , tempDayAwayDuration
        , tempNightAwayDuration
        , tempDayActive
        , temNightActive
        , tempDayActivityLevel
        , tempNightActivityLevel
      FROM get_activity_level_analytics(tempDeviceId, naRow.date_value::date);

      -- Insert into the analytics_value
      SELECT generate_id INTO STRICT nAnalyticsValueId FROM generate_id();
       INSERT INTO analytics_value (
          analytics_value_id
          , analytics_value_name
          , date_value
          , date_value2
          , date_value3
          , value
          , value2
          , value3
          , value4
          , int_value
          , int_value2
          , int_value3
          , int_value4
          , type
          , create_date
          , owner_id
        ) VALUES(
            nAnalyticsValueId
            , 'Activity Level'
            , naRow.date_value
            , tempWakeupTime
            , tempSleepingTime
            , tempDayDuration
            , tempNightDuration
            , tempDayAwayDuration
            , tempNightAwayDuration
            , tempDayActive
            , temNightActive
            , tempDayActivityLevel
            , tempNightActivityLevel
            , 'ACT'
            , (NOW()  at time zone 'utc')::timestamp
            , 'z0a783989897'
        );

        -- insert into the return table for the return data
        INSERT INTO analytics_value_return VALUES
          (
              nAnalyticsValueId
              , naRow.date_value
              , tempWakeupTime
              , tempSleepingTime
              , tempDayDuration
              , tempNightDuration
              , tempDayAwayDuration
              , tempNightAwayDuration
              , tempDayActive
              , temNightActive
              , tempDayActivityLevel
              , tempNightActivityLevel
              , 'z0a783989897'
          );
    END LOOP;

    --clear the non_analyzed_init table for the next user
    DELETE FROM non_analyzed_init;
--   END LOOP;

  RETURN QUERY
    SELECT
      *
    FROM analytics_value_return;

END;
$BODY$
LANGUAGE plpgsql;