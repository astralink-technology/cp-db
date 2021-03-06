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
        , pDateValue3 timestamp without time zone
        , pDateValueStart timestamp without time zone
        , pDateValueEnd timestamp without time zone
        , pDateValue2Start timestamp without time zone
        , pDateValue2End timestamp without time zone
        , pDateValue3Start timestamp without time zone
        , pDateValue3End timestamp without time zone
        , pValue varchar(32)
        , pValue2 varchar(32)
        , pValue3 varchar(32)
        , pValue4 varchar(32)
        , pIntValue integer
        , pIntValue2 integer
        , pIntValue3 integer
        , pIntValue4 integer
        , pType varchar(8)
        , pOwnerId varchar(32)
        , pPageSize integer
        , pSkipSize integer
        , pDateValueIsNull bool
        , pDateValue2IsNull bool
        , pDateValue3IsNull bool
        , pValueIsNull bool
        , pValue2IsNull bool
        , pValue3IsNull bool
        , pValue4IsNull bool
        , pIntValueIsNull bool
        , pIntValue2IsNull bool
        , pIntValue3IsNull bool
        , pIntValue4IsNull bool
    )
RETURNS TABLE(
	analytics_value_id varchar(32)
  , analytics_value_name varchar(32)
  , date_value timestamp without time zone
  , date_value2 timestamp without time zone
  , date_value3 timestamp without time zone
  , value varchar(32)
  , value2 varchar(32)
  , value3 varchar(32)
  , value4 varchar(32)
  , int_value integer
  , int_value2 integer
  , int_value3 integer
  , int_value4 integer
  , type varchar(8)
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
        , av.date_value3
        , av.value
        , av.value2
        , av.value3
        , av.value4
        , av.int_value
        , av.int_value2
        , av.int_value3
        , av.int_value4
        , av.type
        , av.create_date
        , av.owner_id
          FROM analytics_value av WHERE (
           ((pAnalyticsValueId IS NULL) OR (av.analytics_value_id = pAnalyticsValueId)) AND
           ((pAnalyticsValueName IS NULL) OR (av.analytics_value_name = pAnalyticsValueName)) AND
           ((pDateValue IS NULL) OR (av.date_value = pDateValue)) AND
           ((pDateValue2 IS NULL) OR (av.date_value2 = pDateValue2)) AND
           ((pDateValue3 IS NULL) OR (av.date_value3 = pDateValue3)) AND
           ((pDateValueStart IS NULL OR pDateValueEnd IS NULL) OR (av.date_value BETWEEN pDateValueStart AND pDateValueEnd)) AND
           ((pDateValue2Start IS NULL OR pDateValue2End IS NULL) OR (av.date_value2 BETWEEN pDateValue2Start AND pDateValue2End)) AND
           ((pDateValue3Start IS NULL OR pDateValue3End IS NULL) OR (av.date_value3 BETWEEN pDateValue3Start AND pDateValue3End)) AND
           ((pValue IS NULL) OR (av.value = pValue)) AND
           ((pValue2 IS NULL) OR (av.value2 = pValue2)) AND
           ((pValue3 IS NULL) OR (av.value3 = pValue3)) AND
           ((pValue4 IS NULL) OR (av.value4 = pValue4)) AND
           ((pIntValue IS NULL) OR (av.int_value = pIntValue)) AND
           ((pIntValue2 IS NULL) OR (av.int_value2 = pIntValue2)) AND
           ((pIntValue3 IS NULL) OR (av.int_value3 = pIntValue3)) AND
           ((pIntValue4 IS NULL) OR (av.int_value4 = pIntValue4)) AND
           ((pType IS NULL) OR (av.type = pType)) AND
           ((pOwnerId IS NULL) OR (av.owner_id = pOwnerId)) AND
           ((pDateValueIsNull IS NULL) OR ((pDateValueIsNull = false) AND (av.date_value IS NOT NULL))) AND
           ((pDateValue2IsNull IS NULL) OR ((pDateValue2IsNull = false) AND (av.date_value2 IS NOT NULL))) AND
           ((pDateValue3IsNull IS NULL) OR ((pDateValue3IsNull = false) AND (av.date_value3 IS NOT NULL))) AND
           ((pValueIsNull IS NULL) OR ((pValueIsNull = false) AND (av.value IS NOT NULL))) AND
           ((pValue2IsNull IS NULL) OR ((pValue2IsNull = false) AND (av.value2 IS NOT NULL))) AND
           ((pValue3IsNull IS NULL) OR ((pValue3IsNull = false) AND (av.value3 IS NOT NULL))) AND
           ((pValue4IsNull IS NULL) OR ((pValue4IsNull = false) AND (av.value4 IS NOT NULL))) AND
           ((pIntValueIsNull IS NULL) OR ((pIntValueIsNull = false) AND (av.int_value IS NOT NULL))) AND
           ((pIntValue2IsNull IS NULL) OR ((pIntValue2IsNull = false) AND (av.int_value2 IS NOT NULL))) AND
           ((pIntValue3IsNull IS NULL) OR ((pIntValue3IsNull = false) AND (av.int_value3 IS NOT NULL))) AND
           ((pIntValue4IsNull IS NULL) OR ((pIntValue4IsNull = false) AND (av.int_value4 IS NOT NULL)))
          )
          ORDER BY date_value DESC
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM analytics_value_init;
;
END;
$BODY$
LANGUAGE plpgsql;