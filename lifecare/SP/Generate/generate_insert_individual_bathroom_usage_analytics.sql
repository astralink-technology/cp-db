-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'generate_insert_individual_bathroom_usage_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION generate_insert_individual_bathroom_usage_analytics(
        pDeviceId varchar(32)
        , pEntityId varchar(32)
        , pDay date
        )
RETURNS TABLE (
    analytics_value_id varchar(32)
    , date_value timestamp without time zone
    , bathroom_usage_start timestamp without time zone
    , bathroom_usage_end timestamp without time zone
    , bathroom_usage_count integer
    , bathroom_usage_interval integer
    , owner_id varchar(32)
    , entity_id varchar(32)
)
AS
$BODY$
DECLARE
    bathroomRow record;

    bathroomRowCount integer;
    oBathroomCount integer;

    tempDeploymentDate date;
    tempEntityId varchar(32);
    tempDeviceId varchar(32);

    nAnalyticsValueId varchar(32);
BEGIN
  -- Create a temp table for returning
  CREATE TEMP TABLE analytics_value_return(
    analytics_value_id varchar(32)
    , date_value timestamp without time zone
    , bathroom_usage_start timestamp without time zone
    , bathroom_usage_end timestamp without time zone
    , bathroom_usage_count integer
    , bathroom_usage_interval integer
    , owner_id varchar(32)
    , entity_id varchar(32)
  );

  DELETE FROM analytics_value_return;
  
  -- Create a temp table for storing all the bathroom usage values
  CREATE TEMP TABLE bathroom_values_temp AS
      SELECT * FROM get_bathroom_usage_analytics(pDeviceId, pDay);

    SELECT COUNT(*) INTO bathroomRowCount FROM bathroom_values_temp;

    IF bathroomRowCount > 0 THEN
      oBathroomCount := 0;
      FOR bathroomRow IN SELECT * FROM bathroom_values_temp LOOP
        -- generate the ID
        SELECT generate_id INTO STRICT nAnalyticsValueId FROM generate_id();

        -- get the number of bathroom usages
        oBathroomCount := oBathroomCount + 1;

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
            , entity_id
        ) VALUES(
              nAnalyticsValueId
              , 'Bathroom Usage'
              , pDay::timestamp
              , bathroomRow.bathroom_usage_start
              , bathroomRow.bathroom_usage_end
              , null
              , null
              , oBathroomCount
              , bathroomRow.bathroom_usage_interval
              , 'B'
              , (NOW() at time zone 'utc')::timestamp
              , pDeviceId
              , pEntityId
        );
        -- insert into the return table for the return data
        INSERT INTO analytics_value_return VALUES
          (
              nAnalyticsValueId
              , pDay::timestamp
              , bathroomRow.bathroom_usage_start
              , bathroomRow.bathroom_usage_end
              , oBathroomCount
              , bathroomRow.bathroom_usage_interval
              , pDeviceId
              , pEntityId
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
          , entity_id
        ) VALUES(
            nAnalyticsValueId
            , 'Bathroom Usage'
            , pDay::timestamp
            , null
            , null
            , null
            , null
            , null
            , null
            , 'B'
            , (NOW() at time zone 'utc')::timestamp
            , pDeviceId
            , pEntityId
        );
        -- insert into the return table for the return data
        INSERT INTO analytics_value_return VALUES
          (
              nAnalyticsValueId
              , pDay::timestamp
              , null
              , null
              , null
              , null
              , pDeviceId
              , pEntityId
          );
    END IF;

    DROP TABLE bathroom_values_temp;

  RETURN QUERY
    SELECT
      *
    FROM analytics_value_return;

END;
$BODY$
LANGUAGE plpgsql;