-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_core_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_core_analytics(
    pCoreAnalyticsId varchar(32)
    , pAnalyticsName varchar(32)
    , pDateValue timestamp without time zone
    , pDateValue2 timestamp without time zone
    , pDateValue3 timestamp without time zone
    , pDateValue4 timestamp without time zone
    , pValue varchar(32)
    , pValue2 varchar(32)
    , pValue3 varchar(32)
    , pValue4 varchar(32)
    , pIntValue integer
    , pIntValue2 integer
    , pIntValue3 integer
    , pIntValue4 integer
    , pType varchar(8)
    , pDescription text
    , pCreateDate timestamp without time zone
    , pLastUpdate timestamp without time zone
)
RETURNS varchar(32) AS
$BODY$
BEGIN
    INSERT INTO core_analytics(
      core_analytics_id
      , analytics_name
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
      , description
      , create_date
      , last_update
    ) VALUES(
        pCoreAnalyticsId
        , pAnalyticsName
        , pDateValue
        , pDateValue2
        , pDateValue3
        , pDateValue4
        , pValue
        , pValue2
        , pValue3
        , pValue4
        , pIntValue
        , pIntValue2
        , pIntValue3
        , pIntValue4
        , pType
        , pDescription
        , pCreateDate
        , pLastUpdate
    );
    RETURN pCoreAnalyticsId;
END;
$BODY$
LANGUAGE plpgsql;