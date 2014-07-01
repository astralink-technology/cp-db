-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_informative_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_informative_analytics(
      pInformativeAnalyticsId varchar(32)
      , pName varchar(32)
      , pDateValue timestamp without time zone
      , pDateValue2 timestamp without time zone
      , pDateValue3 timestamp without time zone
      , pDateValue4 timestamp without time zone
      , pDateValueStart timestamp without time zone
      , pDateValueEnd timestamp without time zone
      , pDateValueStart2 timestamp without time zone
      , pDateValueEnd2 timestamp without time zone
      , pDateValueStart3 timestamp without time zone
      , pDateValueEnd3 timestamp without time zone
      , pDateValueStart4 timestamp without time zone
      , pDateValueEnd4 timestamp without time zone
      , pValue varchar(32)
      , pValue2 varchar(32)
      , pValue3 varchar(32)
      , pValue4 varchar(32)
      , pIntValue integer
      , pIntValue2 integer
      , pIntValue3 integer
      , pIntValue4 integer
      , pType char(2)
      , pOwnerId varchar(32)
    )
RETURNS TABLE(
      informative_analytics_id varchar(32)
      , name varchar(32)
      , date_value timestamp without time zone
      , date_value2 timestamp without time zone
      , date_value3 timestamp without time zone
      , date_value4 timestamp without time zone
      , value varchar(32)
      , value2 varchar(32)
      , value3 varchar(32)
      , value4 varchar(32)
      , int_value integer
      , int_value2 integer
      , int_value3 integer
      , int_value4 integer
      , type char(2)
      , create_date timestamp without time zone
      , owner_id varchar(32)
      , total_rows integer
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
    FROM informative_analytics;

    -- create a temp table to get the data
    CREATE TEMP TABLE informative_analytics_init AS
      SELECT
            ia.informative_analytics_id
            , ia.name
            , ia.date_value
            , ia.date_value2
            , ia.date_value3
            , ia.date_value4
            , ia.value
            , ia.value2
            , ia.value3
            , ia.value4
            , ia.int_value
            , ia.int_value2
            , ia.int_value3
            , ia.int_value4
            , ia.type
            , ia.create_date
            , ia.owner_id
          FROM informative_analytics ia WHERE (
           ((pInformativeAnalyticsId IS NULL) OR (ia.informative_analytics_id = pInformativeAnalyticsId)) AND
           ((pName IS NULL) OR (ia.name = pName)) AND
           ((pDateValue IS NULL) OR (ia.date_value = pDateValue)) AND
           ((pDateValue2 IS NULL) OR (ia.date_value2 = pDateValue2)) AND
           ((pDateValue3 IS NULL) OR (ia.date_value3 = pDateValue3)) AND
           ((pDateValue4 IS NULL) OR (ia.date_value4 = pDateValue4)) AND
           ((pDateValueStart IS NULL OR pDateValueEnd IS NULL) OR (ia.date_value BETWEEN pDateValueStart AND pDateValueEnd)) AND
           ((pDateValueStart2 IS NULL OR pDateValueEnd2 IS NULL) OR (ia.date_value2 BETWEEN pDateValueStart2 AND pDateValueEnd2)) AND
           ((pDateValueStart3 IS NULL OR pDateValueEnd3 IS NULL) OR (ia.date_value3 BETWEEN pDateValueStart3 AND pDateValueEnd3)) AND
           ((pDateValueStart4 IS NULL OR pDateValueEnd4 IS NULL) OR (ia.date_value4 BETWEEN pDateValueStart4 AND pDateValueEnd4)) AND
           ((pValue IS NULL) OR (ia.value = pValue)) AND
           ((pValue2 IS NULL) OR (ia.value2 = pValue2)) AND
           ((pValue3 IS NULL) OR (ia.value3 = pValue3)) AND
           ((pValue4 IS NULL) OR (ia.value4 = pValue4)) AND
           ((pIntValue IS NULL) OR (ia.int_value = pIntValue)) AND
           ((pIntValue2 IS NULL) OR (ia.int_value2 = pIntValue2)) AND
           ((pIntValue3 IS NULL) OR (ia.int_value3 = pIntValue3)) AND
           ((pIntValue4 IS NULL) OR (ia.int_value4 = pIntValue4)) AND
           ((pType IS NULL) OR (ia.type = pType)) AND
           ((pOwnerId IS NULL) OR (ia.owner_id = pOwnerId))
          )
          ORDER BY ia.create_date DESC;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM informative_analytics_init;

END;
$BODY$
LANGUAGE plpgsql;