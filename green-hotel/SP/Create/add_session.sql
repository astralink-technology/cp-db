-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_session' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_session(
        pSessionId VARCHAR(32)
        , pStartDate TIMESTAMP WITHOUT TIME ZONE
        , pEndDate TIMESTAMP WITHOUT TIME ZONE
        , pCreateDate TIMESTAMP WITHOUT TIME ZONE
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
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO session (
        session_id
        , start_date
        , end_date
        , create_date
        , type
        , status
        , value
        , value2
        , value3
        , int_value
        , int_value2
        , int_value3
        , owner_id
        , object_id
    ) VALUES(
        pSessionId
        , pStartDate
        , pEndDate
        , pCreateDate
        , pType
        , pStatus
        , pValue
        , pValue2
        , pValue3
        , pIntValue
        , pIntValue2
        , pIntValue3
        , pOwnerId
        , pObjectId
    );
    RETURN pSessionId;
END;
$BODY$
LANGUAGE plpgsql;