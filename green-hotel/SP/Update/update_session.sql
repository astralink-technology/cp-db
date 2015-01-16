-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_session' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_session(
    pSessionId VARCHAR(32)
    , pStartDate TIMESTAMP WITHOUT TIME ZONE
    , pEndDate TIMESTAMP WITHOUT TIME ZONE
    , pType VARCHAR(4)
    , pStatus CHAR(1)
    , pValue VARCHAR(32)
    , pValue2 VARCHAR(32)
    , pValue3 VARCHAR(32)
    , pIntValue DECIMAL
    , pIntValue2 DECIMAL
    , pIntValue3 DECIMAL
    , pOwnerId VARCHAR(32)
    , pObjectId VARCHAR(32)
)
RETURNS BOOL AS
$BODY$
DECLARE
      oStartDate TIMESTAMP WITHOUT TIME ZONE;
      oEndDate TIMESTAMP WITHOUT TIME ZONE;
      oType VARCHAR(4);
      oStatus CHAR(1);
      oValue VARCHAR(32);
      oValue2 VARCHAR(32);
      oValue3 VARCHAR(32);
      oIntValue DECIMAL;
      oIntValue2 DECIMAL;
      oIntValue3 DECIMAL;
      oOwnerId VARCHAR(32);
      oObjectId VARCHAR(32);

      nStartDate TIMESTAMP WITHOUT TIME ZONE;
      nEndDate TIMESTAMP WITHOUT TIME ZONE;
      nType VARCHAR(4);
      nStatus CHAR(1);
      nValue VARCHAR(32);
      nValue2 VARCHAR(32);
      nValue3 VARCHAR(32);
      nIntValue DECIMAL;
      nIntValue2 DECIMAL;
      nIntValue3 DECIMAL;
      nOwnerId VARCHAR(32);
      nObjectId VARCHAR(32);
BEGIN
    -- Session ID is needed if not return
    IF pSessionId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            s.start_date
            , s.end_date
            , s.type
            , s.status
            , s.value
            , s.value2
            , s.value3
            , s.int_value
            , s.int_value2
            , s.int_value3
            , s.owner_id
            , s.object_id
        INTO  STRICT
            oStartDate
            , oEndDate
            , oType
            , oStatus
            , oValue
            , oValue2
            , oValue3
            , oIntValue
            , oIntValue2
            , oIntValue3
            , oOwnerId
            , oObjectId
        FROM session s WHERE
            s.session_id = pSessionId;

        -- Start the updating process
        IF pStartDate IS NULL THEN
            nStartDate := oStartDate;
        ELSE
            nStartDate := pStartDate;
        END IF;

        IF pEndDate IS NULL THEN
            nEndDate := oEndDate;
        ELSE
            nEndDate := pEndDate;
        END IF;
        
        IF pType IS NULL THEN
            nType := oType;
        ELSEIF pType = '' THEN
            -- defaulted null
            nType := NULL;
        ELSE
            nType := pType;
        END IF;
        
        IF pStatus IS NULL THEN
            nStatus := oStatus;
        ELSEIF pStatus = '' THEN
            -- defaulted null
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
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
        
        IF pIntValue IS NULL THEN
            nIntValue := oIntValue;
        ELSE
            nIntValue := pIntValue;
        END IF;
        
        IF pIntValue2 IS NULL THEN
            nIntValue2 := oIntValue2;
        ELSE
            nIntValue2 := pIntValue2;
        END IF;
        
        IF pIntValue3 IS NULL THEN
            nIntValue3 := oIntValue3;
        ELSE
            nIntValue3 := pIntValue3;
        END IF;
        
        IF pOwnerId IS NULL THEN
            nOwnerId := oOwnerId;
        ELSEIF pOwnerId = '' THEN
            -- defaulted null
            nOwnerId := NULL;
        ELSE
            nOwnerId := pOwnerId;
        END IF;
        
        IF pObjectId IS NULL THEN
            nObjectId := oObjectId;
        ELSEIF pObjectId = '' THEN
            -- defaulted null
            nObjectId := NULL;
        ELSE
            nObjectId := pObjectId;
        END IF;

        -- start the update
        UPDATE
            session
        SET
            start_date = nStartDate
            , end_date = nEndDate
            , type = nType
            , status = nStatus
            , value = nValue
            , value2 = nValue2
            , value3 = nValue3
            , int_value = nIntValue
            , int_value2 = nIntValue2
            , int_value3 = nIntValue3
            , owner_id = nOwnerId
            , object_id = nObjectId
        WHERE
            session_id = pSessionId;

        RETURN TRUE;

    END IF;
END;
$BODY$
LANGUAGE plpgsql;