-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'generate_insert_individual_away_mode_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION generate_insert_individual_away_mode_analytics(
        pDeviceId varchar(32)
        , pDay date
        )
RETURNS TABLE (
    analytics_value_id varchar(32),
    date_value timestamp without time zone,
    away_start timestamp without time zone,
    away_end timestamp without time zone,
    away_count integer,
    day_of_week_away integer,
    owner_id varchar(32)
)
AS
$BODY$
DECLARE
    awayRow record;

    tempDeploymentDate date;
    tempEntityId varchar(32);
    tempDeviceId varchar(32);

    awayRowCount integer;
    oDowForAwayStart integer;
    oAwayCount integer;

    nAnalyticsValueId varchar(32);
BEGIN

  -- Create a temp table for returning
  CREATE TEMP TABLE IF NOT EXISTS analytics_value_return(
    analytics_value_id varchar(32),
    date_value timestamp without time zone,
    away_start timestamp without time zone,
    away_end timestamp without time zone,
    away_count integer,
    day_of_week_away integer,
    owner_id varchar(32)
  ) ON COMMIT DROP;

  DELETE FROM analytics_value_return;

  CREATE TEMP TABLE away_values_temp AS
      SELECT * FROM get_away_analytics(pDeviceId, pDay);

  SELECT COUNT(*) INTO awayRowCount FROM away_values_temp;

  IF awayRowCount > 0 THEN
    oAwayCount := 0;
    FOR awayRow IN SELECT * FROM away_values_temp LOOP
      -- generate the ID
      SELECT generate_id INTO STRICT nAnalyticsValueId FROM generate_id();

      -- get the day of the week of the away
      IF awayRow.away_start IS NOT NULL THEN
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
    FROM analytics_value_return;

END;
$BODY$
LANGUAGE plpgsql;