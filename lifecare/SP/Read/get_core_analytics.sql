-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_core_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_core_analytics(
        pCoreAnalyticsId varchar(32)
        , pDateValue timestamp without time zone
        , pDateValue2 timestamp without time zone
        , pDateValue3 timestamp without time zone
        , pDateValue4 timestamp without time zone
        , pDateValueStart timestamp without time zone
        , pDateValueEnd timestamp without time zone
        , pDateValue2Start timestamp without time zone
        , pDateValue2End timestamp without time zone
        , pDateValue3Start timestamp without time zone
        , pDateValue3End timestamp without time zone
        , pDateValue4Start timestamp without time zone
        , pDateValue4End timestamp without time zone
        , pValue varchar(32)
        , pValue2 varchar(32)
        , pValue3 varchar(32)
        , pValue4 varchar(32)
        , pIntValue integer
        , pIntValue2 integer
        , pIntValue3 integer
        , pIntValue4 integer
        , pType char(1)
    )
RETURNS TABLE(
    core_analytics_id varchar(32),
    analytics_name varchar(32),
    date_value timestamp without time zone,
    date_value2 timestamp without time zone,
    date_value3 timestamp without time zone,
    date_value4 timestamp without time zone,
    value varchar(32),
    value2 varchar(32),
    value3 varchar(32),
    value4 varchar(32),
    int_value integer,
    int_value2 integer,
    int_value3 integer,
    int_value4 integer,
    type char(1),
    description text,
    create_date timestamp without time zone,
    last_update timestamp without time zone,
    total_rows integer
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
    FROM core_analytics;

    -- create a temp table to get the data
    CREATE TEMP TABLE core_analytics_init AS
      SELECT
            ca.core_analytics_id
            , ca.analytics_name
            , ca.date_value
            , ca.date_value2
            , ca.date_value3
            , ca.date_value4
            , ca.value
            , ca.value2
            , ca.value3
            , ca.value4
            , ca.int_value
            , ca.int_value2
            , ca.int_value3
            , ca.int_value4
            , ca.type
            , ca.description
            , ca.create_date
            , ca.last_update
          FROM core_analytics ca WHERE (
           ((pCoreAnalyticsId IS NULL) OR (ca.core_analytics_id = pCoreAnalyticsId)) AND
           ((pDateValue IS NULL) OR (ca.date_value = pDateValue)) AND
           ((pDateValue2 IS NULL) OR (ca.date_value2 = pDateValue2)) AND
           ((pDateValue3 IS NULL) OR (ca.date_value3 = pDateValue3)) AND
           ((pDateValue4 IS NULL) OR (ca.date_value4 = pDateValue4)) AND
           ((pDateValueStart IS NULL OR pDateValueEnd IS NULL) OR (ca.date_value BETWEEN pDateValueStart AND pDateValueEnd)) AND
           ((pDateValue2Start IS NULL OR pDateValue2End IS NULL) OR (ca.date_value2 BETWEEN pDateValue2Start AND pDateValue2End)) AND
           ((pDateValue3Start IS NULL OR pDateValue3End IS NULL) OR (ca.date_value3 BETWEEN pDateValue3Start AND pDateValue3End)) AND
           ((pDateValue4Start IS NULL OR pDateValue4End IS NULL) OR (ca.date_value4 BETWEEN pDateValue4Start AND pDateValue4End)) AND
           ((pValue IS NULL) OR (ca.value = pValue)) AND
           ((pValue2 IS NULL) OR (ca.value2 = pValue2)) AND
           ((pValue3 IS NULL) OR (ca.value3 = pValue3)) AND
           ((pValue4 IS NULL) OR (ca.value4 = pValue4)) AND
           ((pIntValue IS NULL) OR (ca.int_value = pIntValue)) AND
           ((pIntValue2 IS NULL) OR (ca.int_value2 = pIntValue2)) AND
           ((pIntValue3 IS NULL) OR (ca.int_value3 = pIntValue3)) AND
           ((pIntValue4 IS NULL) OR (ca.int_value4 = pIntValue4)) AND
           ((pType IS NULL) OR (ca.type = pType))
          )
          ORDER BY ca.date_value DESC;

    RETURN QUERY
      SELECT
        *
        , totalRows
      FROM core_analytics_init;

END;
$BODY$
LANGUAGE plpgsql;