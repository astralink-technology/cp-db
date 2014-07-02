-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_informative_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_informative_analytics(
    pInformativeAnalyticsId varchar(32)
    , pName varchar(32)
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
    , pType varchar(4)
    , pCreateDate timestamp without time zone
    , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO informative_analytics(
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
        pInformativeAnalyticsId
        , pName
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
        , pCreateDate
        , pOwnerId
    );
    RETURN pInformativeAnalyticsId;
END;
$BODY$
LANGUAGE plpgsql;