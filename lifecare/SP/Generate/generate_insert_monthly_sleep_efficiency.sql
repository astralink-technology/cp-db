-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'generate_insert_monthly_sleep_efficiency' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION generate_insert_monthly_sleep_efficiency(
  pMonthStart date
  , pMonthEnd date
)
RETURNS TABLE (
    informative_analytics_id varchar(32)
    , device_id varchar(32)
    , monthly_sleep_efficiency integer
)
AS
$BODY$
DECLARE
    uRow record;

    pSleepEfficiencyCount integer;
    pMonthlySleepEfficiency integer;
    pInformativeAnalyticsExistCount integer;

    nInformativeAnalyticsId varchar(32);
BEGIN
  -- Create a temp table for returning
  CREATE TEMP TABLE IF NOT EXISTS monthly_sleep_efficiency_init(
    informative_analytics_id varchar(32)
    , device_id varchar(32)
    , monthly_sleep_effiency integer
  ) ON COMMIT DROP;

  -- clear the table
  DELETE FROM monthly_sleep_efficiency_init;

  -- Get all users with valid
  CREATE TEMP TABLE IF NOT EXISTS user_init(
        owner_id varchar(32)
        , device_id varchar(32)
        , deployment_date date
        , type char(1)
  ) ON COMMIT DROP;
  -- clear the table
  DELETE FROM user_init;

  INSERT INTO user_init
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


  pMonthlySleepEfficiency = 0;
  pSleepEfficiencyCount = 0;

  FOR uRow IN SELECT * FROM user_init LOOP

    SELECT
      COUNT(*)
    INTO
      pInformativeAnalyticsExistCount
    FROM informative_analytics WHERE
      owner_id = uRow.device_id AND
      type = 'MSE' AND
      date_value = (NOW()::date || ' ' || '00:00:00')::timestamp;

    IF pInformativeAnalyticsExistCount < 1 THEN
      SELECT
        COUNT(*)
      INTO
        pSleepEfficiencyCount
      FROM
        informative_analytics
      WHERE type = 'SE' AND
        date_value BETWEEN (pMonthStart || ' ' || '00:00:00')::timestamp AND (pMonthEnd || ' ' || '23:59:59')::timestamp AND
        int_value IS NOT NULL AND
        owner_id = uRow.device_id;

      IF pSleepEfficiencyCount > 0 THEN
        SELECT
          (SUM(int_value) / COUNT(*))::integer
        INTO
          pMonthlySleepEfficiency
        FROM
          informative_analytics
        WHERE type = 'SE' AND
          date_value BETWEEN (pMonthStart || ' ' || '00:00:00')::timestamp AND (pMonthEnd || ' ' || '23:59:59')::timestamp AND
          int_value IS NOT NULL AND
          owner_id = uRow.device_id;
      ELSE
        pMonthlySleepEfficiency = null;
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
        ) VALUES(
            nInformativeAnalyticsId
            , 'Monthly Sleep Efficiency'
            , (NOW()::date || ' ' || '00:00:00')::timestamp
            , null
            , null
            , null
            , null
            , null
            , null
            , null
            , pMonthlySleepEfficiency
            , null
            , null
            , null
            , 'MSE'
            , (NOW() at time zone 'utc')::timestamp
            , uRow.device_id
        );

        -- insert into the return table for the return data
        INSERT INTO monthly_sleep_efficiency_init VALUES
          (
              nInformativeAnalyticsId
              , uRow.device_id
              , pMonthlySleepEfficiency
          );
    END IF;

  END LOOP;


  RETURN QUERY
    SELECT
      *
    FROM monthly_sleep_efficiency_init;

END;
$BODY$
LANGUAGE plpgsql;