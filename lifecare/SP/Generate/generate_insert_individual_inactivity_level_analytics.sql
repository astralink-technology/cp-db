-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'generate_insert_individual_inactivity_level_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION generate_insert_individual_inactivity_level_analytics(
        pDeviceId varchar(32)
        , pEntityId varchar(32)
        , pDay date
        , pType varchar(8)
)
RETURNS TABLE (
    analytics_value_id varchar(32)
    , analytics_value_name varchar(32)
    , date_value timestamp without time zone
    , inactivity_start timestamp without time zone
    , inactivity_end timestamp without time zone
    , inactivity_level integer
    , type varchar(8)
    , owner_id varchar(32)
    , entity_id varchar(32)
)
AS
$BODY$
DECLARE

    iaRows record;
    iaRowCount integer;

    nAnalyticsValueId varchar(32);
    nAnalyticsValueName varchar(32);

BEGIN

  -- Create a temp table for returning
  CREATE TEMP TABLE IF NOT EXISTS analytics_value_return(
    analytics_value_id varchar(32)
    , analytics_value_name varchar(32)
    , date_value timestamp without time zone
    , inactivity_start timestamp without time zone
    , inactivity_end timestamp without time zone
    , inactivity_level integer
    , type varchar(8)
    , owner_id varchar(32)
    , entity_id varchar(32)
  )ON COMMIT DROP;

  CREATE TEMP TABLE IF NOT EXISTS inactivity_levels_analytics_init(
      eyecare_id varchar(32)
      , inactivity_duration integer
      , next_row_create_date timestamp without time zone
      , prev_row_create_date timestamp without time zone
      , create_date timestamp without time zone
      , wakeup_time timestamp without time zone
      , sleep_time timestamp without time zone
  )ON COMMIT DROP;
  -- clear the table
  DELETE FROM inactivity_levels_analytics_init;

  -- For row that is not analyzed for the user, find the wake up time and do the insert
  IF pType = 'NIA' THEN
    INSERT INTO inactivity_levels_analytics_init (
      eyecare_id
      , inactivity_duration
      , next_row_create_date
      , prev_row_create_date
      , create_date
      , wakeup_time
      , sleep_time
    )
      SELECT *
      FROM get_night_inactivity_level_analytics(pDeviceId, pDay);

    nAnalyticsValueName = 'Night Inactivity Level';

  ELSEIF pType = 'DIA' THEN
    INSERT INTO inactivity_levels_analytics_init (
      eyecare_id
      , inactivity_duration
      , next_row_create_date
      , prev_row_create_date
      , create_date
      , wakeup_time
      , sleep_time
    )
      SELECT *
      FROM get_day_inactivity_level_analytics(pDeviceId, pDay);

    nAnalyticsValueName = 'Day Inactivity Level';

  END IF;

  SELECT
    COUNT(*)
  INTO
    iaRowCount
  FROM inactivity_levels_analytics_init;

  IF iaRowCount > 0 THEN
    FOR iaRows IN SELECT * FROM inactivity_levels_analytics_init LOOP
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
            , nAnalyticsValueName
            , pDay::timestamp
            , iaRows.create_date
            , iaRows.next_row_create_date
            , null
            , null
            , null
            , null
            , iaRows.inactivity_duration
            , null
            , null
            , null
            , pType
            , (NOW() at time zone 'utc')::timestamp
            , pDeviceId
            , pEntityId
        );

        -- insert into the return table for the return data
        INSERT INTO analytics_value_return VALUES
          (
              nAnalyticsValueId
              , nAnalyticsValueName
              , pDay::timestamp
              , iaRows.create_date
              , iaRows.next_row_create_date
              , iaRows.inactivity_duration
              , pType
              , pDeviceId
            , pEntityId
          );
    END LOOP;
  ELSE
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
            , nAnalyticsValueName
            , pDay::timestamp
            , null
            , null
            , null
            , null
            , null
            , null
            , null
            , null
            , null
            , null
            , pType
            , (NOW() at time zone 'utc')::timestamp
            , pDeviceId
            , pEntityId
        );

        -- insert into the return table for the return data
        INSERT INTO analytics_value_return VALUES
          (
              nAnalyticsValueId
              , nAnalyticsValueName
              , pDay::timestamp
              , null
              , null
              , null
              , pType
              , pDeviceId
              , pEntityId
          );
  END IF;

  RETURN QUERY
    SELECT
      *
    FROM analytics_value_return;

END;
$BODY$
LANGUAGE plpgsql;