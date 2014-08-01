-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'generate_insert_average_activity_level' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION generate_insert_average_activity_level()
RETURNS TABLE (
    informative_analytics_id varchar(32)
    , device_id varchar(32)
    , average_day_activity_level integer
    , average_night_activity_level integer
)
AS
$BODY$
DECLARE
    uRow record;

    pAverageDayActivityLevel integer;
    pAverageNightActivityLevel integer;
    pInformativeAnalyticsExistCount integer;

    nInformativeAnalyticsId varchar(32);
BEGIN
  -- Create a temp table for returning
  CREATE TEMP TABLE IF NOT EXISTS average_activity_level_init(
    informative_analytics_id varchar(32)
    , device_id varchar(32)
    , average_day_activity_level integer
    , average_night_activity_level integer
  ) ON COMMIT DROP;

  -- clear the table
  DELETE FROM average_activity_level_init;

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


  pAverageDayActivityLevel = 0;
  pAverageNightActivityLevel = 0;

  FOR uRow IN SELECT * FROM user_away_init LOOP

    SELECT
      COUNT(*)
    INTO
      pInformativeAnalyticsExistCount
    FROM informative_analytics WHERE
      owner_id = uRow.device_id AND
      type = 'AVGACT' AND
      date_value = (NOW()::date || ' ' || '00:00:00')::timestamp;

    IF pInformativeAnalyticsExistCount < 1 THEN
      -- For row that is not analyzed for the user, find the wake up time and do the insert
      SELECT
       SUM(int_value3) / COUNT(*)
      INTO
        pAverageDayActivityLevel
      FROM analytics_value WHERE
        owner_id = uRow.device_id and type = 'ACT' and int_value3 BETWEEN 0 AND 100;

      SELECT
       SUM(int_value4) / COUNT(*)
      INTO
        pAverageNightActivityLevel
      FROM analytics_value WHERE
        owner_id = uRow.device_id and type = 'ACT' and int_value4 BETWEEN 0 AND 100;

      -- Insert into the analytics_value
      SELECT generate_id INTO STRICT nInformativeAnalyticsId FROM generate_id();
       INSERT INTO informative_analytics (
          informative_analytics_id
          , name
          , date_value
          , date_value2
          , date_value3
          , date_value4
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
            nInformativeAnalyticsId
            , 'Average Activity Level'
            , (NOW()::date || ' ' || '00:00:00')::timestamp
            , null
            , null
            , null
            , null
            , null
            , null
            , null
            , pAverageDayActivityLevel
            , pAverageNightActivityLevel
            , null
            , null
            , 'AVGACT'
            , (NOW() at time zone 'utc')::timestamp
            , uRow.device_id
        );

        -- insert into the return table for the return data
        INSERT INTO average_activity_level_init VALUES
          (
              nInformativeAnalyticsId
              , uRow.device_id
              , pAverageDayActivityLevel
              , pAverageNightActivityLevel
          );
    END IF;

  END LOOP;


  RETURN QUERY
    SELECT
      *
    FROM average_activity_level_init;

END;
$BODY$
LANGUAGE plpgsql;