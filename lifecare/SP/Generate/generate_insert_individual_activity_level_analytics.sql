-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'generate_insert_individual_activity_level_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION generate_insert_individual_activity_level_analytics(
        pDeviceId varchar(32)
        , pEntityId varchar(32)
        , pDay date
)
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
    , entity_id varchar(32)
)
AS
$BODY$
DECLARE

    tempWakeupTime timestamp without time zone default null;
    tempSleepingTime timestamp without time zone default null;
    tempDayDuration integer default null;
    tempNightDuration integer default null;
    tempDayAwayDuration integer default null;
    tempNightAwayDuration integer default null;
    tempDayActive integer default null;
    tempNightActive integer default null;
    tempDayActivityLevel integer default null;
    tempNightActivityLevel integer default null;

    nAnalyticsValueId varchar(32);
BEGIN

  -- Create a temp table for returning
  CREATE TEMP TABLE analytics_value_return(
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
    , entity_id varchar(32)
  );

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
    , tempNightActive
    , tempDayActivityLevel
    , tempNightActivityLevel
  FROM get_activity_level_analytics(pDeviceId, pDay);

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
      , entity_id
    ) VALUES(
        nAnalyticsValueId
        , 'Activity Level'
        , pDay::timestamp
        , tempWakeupTime
        , tempSleepingTime
        , tempDayDuration
        , tempNightDuration
        , tempDayAwayDuration
        , tempNightAwayDuration
        , tempDayActive
        , tempNightActive
        , tempDayActivityLevel
        , tempNightActivityLevel
        , 'ACT'
        , (NOW() at time zone 'utc')::timestamp
        , pDeviceId
        , pEntityId
    );

    -- insert into the return table for the return data
    INSERT INTO analytics_value_return VALUES
      (
          nAnalyticsValueId
          , pDay::timestamp
          , tempWakeupTime
          , tempSleepingTime
          , tempDayDuration
          , tempNightDuration
          , tempDayAwayDuration
          , tempNightAwayDuration
          , tempDayActive
          , tempNightActive
          , tempDayActivityLevel
          , tempNightActivityLevel
          , pDeviceId
          , pEntityId
      );

  RETURN QUERY
    SELECT
      *
    FROM analytics_value_return;

END;
$BODY$
LANGUAGE plpgsql;