-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_analytics_value' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_analytics_value(
        pAnalyticsValueId varchar(32)
        , pAnalyticsValueName varchar(32)
        , pDateValue timestamp without time zone
        , pDateValue2 timestamp without time zone
        , pDateValueStart timestamp without time zone
        , pDateValueEnd timestamp without time zone
        , pDateValue2Start timestamp without time zone
        , pDateValue2End timestamp without time zone
        , pValue varchar(32)
        , pValue2 varchar(32)
        , pIntValue integer
        , pIntValue2 integer
        , pType char(1)
        , pOwnerId varchar(32)
    )
RETURNS TABLE(
	analytics_value_id varchar(32)
  , analytics_value_name varchar(32)
  , date_value timestamp without time zone
  , date_value2 timestamp without time zone
  , value varchar(32)
  , value2 varchar(32)
  , int_value integer
  , int_value2 integer
  , type char(1)
	, create_date timestamp without time zone
	, owner_id varchar(32)
	, totalRows integer
  )
AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM analytics_value;

    -- create a temp table to get the data
    CREATE TEMP TABLE analytics_value_init AS
      SELECT
        av.analytics_value_id
        , av.analytics_value_name
        , av.date_value
        , av.date_value2
        , av.value
        , av.value2
        , av.int_value
        , av.int_value2
        , av.type
        , av.create_date
        , av.owner_id
          FROM analytics_value av WHERE (
           ((pAnalyticsValueId IS NULL) OR (av.analytics_value_id = pAnalyticsValueId)) AND
           ((pAnalyticsValueName IS NULL) OR (av.analytics_value_name = pAnalyticsValueName)) AND
           ((pDateValue IS NULL) OR (av.date_value = pDateValue)) AND
           ((pDateValue2 IS NULL) OR (av.date_value2 = pDateValue2)) AND
           ((pDateValueStart IS NULL OR pDateValueEnd IS NULL) OR (av.date_value BETWEEN pDateValueStart AND pDateValueEnd)) AND
           ((pDateValue2Start IS NULL OR pDateValue2End IS NULL) OR (av.date_value2 BETWEEN pDateValue2Start AND pDateValue2End)) AND
           ((pValue IS NULL) OR (av.value = pValue)) AND
           ((pValue2 IS NULL) OR (av.value2 = pValue2)) AND
           ((pIntValue IS NULL) OR (av.int_value = pIntValue)) AND
           ((pIntValue2 IS NULL) OR (av.int_value2 = pIntValue2)) AND
           ((pType IS NULL) OR (av.type = pType)) AND
           ((pOwnerId IS NULL) OR (av.owner_id = pOwnerId))
          );

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM analytics_value_init;

END;
$BODY$
LANGUAGE plpgsql;