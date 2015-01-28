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
    , entity_id varchar(32)
    , name varchar(64)
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

    pDayDataPoints integer;
    pNightDataPoints integer;

    nInformativeAnalyticsId varchar(32);
BEGIN
  -- Create a temp table for returning
  CREATE TEMP TABLE IF NOT EXISTS average_activity_level_init(
    informative_analytics_id varchar(32)
    , device_id varchar(32)
    , entity_id varchar(32)
    , name varchar(64)
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
        , entity_id varchar(32)
        , name varchar(64)
        , deployment_date date
        , type char(1)
  ) ON COMMIT DROP;
  -- clear the table
  DELETE FROM user_away_init;

  INSERT INTO user_away_init
  (
      owner_id
      , device_id
      , entity_id
      , name
      , deployment_date
      , type
  )
    SELECT
      dr.owner_id
      , dr.device_id
      , e.entity_id
      , e.name
      , d.deployment_date
      , d.type
    FROM device_relationship dr INNER JOIN device d ON d.device_id = dr.device_id
    INNER JOIN entity e ON e.entity_id = dr.owner_id
    WHERE d.type = 'L';

  pAverageDayActivityLevel = 0;
  pAverageNightActivityLevel = 0;

  FOR uRow IN SELECT * FROM user_away_init LOOP

    -- check if informative analytics are calculated before
    SELECT
      COUNT(*)
    INTO
      pInformativeAnalyticsExistCount
    FROM informative_analytics ia WHERE
      ia.owner_id = uRow.device_id AND
      ia.entity_id = uRow.entity_id AND
      type = 'AVGACT' AND
      date_value = (NOW()::date || ' ' || '00:00:00')::timestamp;

    -- day data points
    SELECT
      COUNT(dd.*)
    INTO
      pDayDataPoints
    FROM
    (SELECT * FROM analytics_value av WHERE type = 'AH' AND av.owner_id = uRow.device_id AND av.entity_id = uRow.entity_id AND av.int_value3 > 80 ORDER BY av.date_value DESC LIMIT 20) dd;

    -- night data points
    SELECT
      COUNT(nd.*)
    INTO
      pNightDataPoints
    FROM
    (SELECT * FROM analytics_value av WHERE av.type = 'AH' AND av.owner_id = uRow.device_id AND av.entity_id = uRow.entity_id AND av.int_value4 > 80 ORDER BY av.date_value DESC LIMIT 20) nd;

    IF pInformativeAnalyticsExistCount < 1 THEN
      IF pDayDataPoints = 20 THEN
        SELECT
         SUM(int_value3) / COUNT(*)
        INTO
          pAverageDayActivityLevel
        FROM analytics_value av WHERE
          av.date_value IN (SELECT avv.date_value FROM analytics_value avv WHERE avv.type = 'AH' AND avv.owner_id = uRow.device_id AND avv.entity_id = uRow.entity_id AND avv.int_value3 > 80 ORDER BY avv.date_value DESC LIMIT 20) AND
          av.owner_id = uRow.device_id AND av.entity_id = uRow.entity_id AND av.type = 'ACT' AND av.int_value3 BETWEEN 0 AND 100;
      ELSE
        pAverageDayActivityLevel = null;
      END IF;

      IF pNightDataPoints = 20 THEN
        SELECT
         SUM(int_value4) / COUNT(*)
        INTO
          pAverageNightActivityLevel
        FROM analytics_value av WHERE
          av.date_value IN (SELECT avv.date_value FROM analytics_value avv WHERE avv.type = 'AH' AND avv.owner_id = uRow.device_id AND avv.int_value4 > 80 ORDER BY avv.date_value DESC LIMIT 20) AND
          av.owner_id = uRow.device_id AND av.entity_id = uRow.entity_id AND av.type = 'ACT' AND av.int_value4 BETWEEN 0 AND 100;
      ELSE
          pAverageNightActivityLevel = null;
      END IF;

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
          , entity_id
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
            , uRow.entity_Id
        );

        -- insert into the return table for the return data
        INSERT INTO average_activity_level_init VALUES
          (
              nInformativeAnalyticsId
              , uRow.device_id
              , uRow.owner_id
              , uRow.name
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