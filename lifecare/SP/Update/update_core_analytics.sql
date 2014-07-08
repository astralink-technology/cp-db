-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_core_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_core_analytics(
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
        , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oAnalyticsName varchar(32);
    oDateValue timestamp without time zone;
    oDateValue2 timestamp without time zone;
    oDateValue3 timestamp without time zone;
    oDateValue4 timestamp without time zone;
    oValue varchar(32);
    oValue2 varchar(32);
    oValue3 varchar(32);
    oValue4 varchar(32);
    oIntValue integer;
    oIntValue2 integer;
    oIntValue3 integer;
    oIntValue4 integer;
    oType varchar(8);
    oDescription text;
    oLastUpdate timestamp without time zone;

    nAnalyticsName varchar(32);
    nDateValue timestamp without time zone;
    nDateValue2 timestamp without time zone;
    nDateValue3 timestamp without time zone;
    nDateValue4 timestamp without time zone;
    nValue varchar(32);
    nValue2 varchar(32);
    nValue3 varchar(32);
    nValue4 varchar(32);
    nIntValue integer;
    nIntValue2 integer;
    nIntValue3 integer;
    nIntValue4 integer;
    nType varchar(8);
    nDescription text;
    nLastUpdate timestamp without time zone;

BEGIN
    -- Rule ID is needed if not return
    IF pRuleId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            ca.analytics_name
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
            , ca.last_update
        INTO STRICT
           oAnalyticsName
           , oDateValue
           , oDateValue2
           , oDateValue3
           , oDateValue4
           , oValue
           , oValue2
           , oValue3
           , oValue4
           , oIntValue
           , oIntValue2
           , oIntValue3
           , oIntValue4
           , oType
           , oDescription
           , oLastUpdate
        FROM core_analytics ca WHERE
            ca.core_analytics_id = pCoreAnalyticsId;

        -- Start the updating process
        IF pAnalyticsName IS NULL THEN 
            nAnalyticsName := oAnalyticsName;
        ELSEIF pAnalyticsName = '' THEN   
            -- defaulted null
            nAnalyticsName := NULL;
        ELSE
            nAnalyticsName := pAnalyticsName;
        END IF;

        IF pDateValue IS NULL THEN 
            nDateValue := oDateValue;
        ELSE
            nDateValue := pDateValue;
        END IF;
        
        IF pDateValue2 IS NULL THEN 
            nDateValue2 := oDateValue2;
        ELSE
            nDateValue2 := pDateValue2;
        END IF;
        
        IF pDateValue3 IS NULL THEN 
            nDateValue3 := oDateValue3;
        ELSE
            nDateValue3 := pDateValue3;
        END IF;

        IF pDateValue4 IS NULL THEN 
            nDateValue4 := oDateValue4;
        ELSE
            nDateValue4 := pDateValue4;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        IF pValue IS NULL THEN
            nValue := oValue;
        ELSEIF pValue = '' THEN
            -- defaulted null
            nValue := NULL;
        ELSE
            nValue := pValue;
        END IF;

        IF pValue2 IS NULL THEN
            nValue2 := oValue2;
        ELSEIF pValue2 = '' THEN
            -- defaulted null
            nValue2 := NULL;
        ELSE
            nValue2 := pValue2;
        END IF;

        IF pValue3 IS NULL THEN
            nValue3 := oValue3;
        ELSEIF pValue3 = '' THEN
            -- defaulted null
            nValue3 := NULL;
        ELSE
            nValue3 := pValue3;
        END IF;

        IF pValue4 IS NULL THEN
            nValue4 := oValue4;
        ELSEIF pValue4 = '' THEN
            -- defaulted null
            nValue4 := NULL;
        ELSE
            nValue4 := pValue4;
        END IF;

        IF pDescription IS NULL THEN
            nDescription := oDescription;
        ELSEIF pDescription = '' THEN
            -- defaulted null
            nDescription := NULL;
        ELSE
            nDescription := pDescription;
        END IF;

        IF pType IS NULL THEN
            nType := oType;
        ELSEIF pType = '' THEN
            -- defaulted null
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        -- start the update
        UPDATE 
            rule
        SET
            analytics_name = nAnalyticsName
            , date_value = nDateValue
            , date_value2 = nDateValue2
            , date_value3 = nDateValue3
            , date_value4 = nDateValue4
            , value = nValue
            , value2 = nValue2
            , value3 = nValue3
            , value4 = nValue4
            , int_value = nIntValue
            , int_value2 = nIntValue2
            , int_value3 = nIntValue3
            , int_value4 = nIntValue4
            , type = nType
            , description = nDescription
            , last_update = nLastUpdate
        WHERE
            core_analytics_id = pCoreAnalyticsId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;