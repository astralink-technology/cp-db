-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'generate_insert_sleeping_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION generate_insert_sleeping_analytics()
RETURNS TABLE (
    analytics_value_id varchar(32),
    date_value timestamp without time zone,
    date_value_2 timestamp without time zone,
    owner_id varchar(32)
)
AS
$BODY$
DECLARE
    uRow record;
    naRow record;

    tempDeploymentDate date;
    tempEntityId varchar(32);
    tempDeviceId varchar(32);
    tempSleepingTime timestamp without time zone;

    nAnalyticsValueId varchar(32);
BEGIN

  -- Create a temp table for returning
  CREATE TEMP TABLE analytics_value_return(
    analytics_value_id varchar(32),
    date_value timestamp without time zone,
    date_value_2 timestamp without time zone,
    owner_id varchar(32)
  );

  -- Create a temp table to store all the days that has not been analyze
  CREATE TEMP TABLE non_analyzed_init(
      date_value timestamp without time zone
  );

  -- Get all users with valid
  CREATE TEMP TABLE users_init AS
    SELECT
      dr.owner_id
      , dr.device_id
      , d.deployment_date
      , d.type
    FROM device_relationship dr INNER JOIN device d ON d.device_id = dr.device_id WHERE d.type = 'L';

  -- loop through the users
  FOR uRow IN SELECT * FROM users_init LOOP
    tempDeploymentDate = uRow.deployment_date;
    tempEntityId = uRow.owner_id;
    tempDeviceId = uRow.device_id;

    -- get the dates that have not been analyzed
    INSERT INTO non_analyzed_init (date_value)
      SELECT dv as date_value FROM generate_series(tempDeploymentDate::timestamp, (CURRENT_TIMESTAMP::timestamp - (1 * INTERVAL '1 day')), '1 day') as dv WHERE -- always one day before
      dv NOT IN (
        SELECT DISTINCT(av.date_value) FROM analytics_value av WHERE av.owner_id = uRow.device_id AND av.type = 'S'
      );

    FOR naRow IN SELECT * FROM non_analyzed_init LOOP
      -- For row that is not analyzed for the user, find the sleeping time and do the insert
      SELECT
        sleeping_time
      INTO
        tempSleepingTime
      FROM get_sleep_analytics(tempDeviceId, naRow.date_value::date);

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
          , int_value
          , int_value2
          , type
          , create_date
          , owner_id
        ) VALUES(
            nAnalyticsValueId
            , 'Sleeping Time'
            , naRow.date_value
            , tempSleepingTime
            , null
            , null
            , null
            , null
            , null
            , 'S'
            , (NOW()  at time zone 'utc')::timestamp
            , tempDeviceId
        );

        -- insert into the return table for the return data
        INSERT INTO analytics_value_return VALUES
          (
              nAnalyticsValueId
              , naRow.date_value
              , tempSleepingTime
              , tempDeviceId
          );
    END LOOP;

    --clear the non_analyzed_init table for the next user
    DELETE FROM non_analyzed_init;
  END LOOP;

  RETURN QUERY
    SELECT
      *
    FROM analytics_value_return;

END;
$BODY$
LANGUAGE plpgsql;