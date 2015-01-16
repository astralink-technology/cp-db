-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_session_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_session_details(
        pSessionId VARCHAR(32)
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
        , pDeviceId  VARCHAR(32)
        , pRoomId VARCHAR(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
  session_id VARCHAR(32)
  , start_date TIMESTAMP WITHOUT TIME ZONE
  , end_date TIMESTAMP WITHOUT TIME ZONE
  , create_date TIMESTAMP WITHOUT TIME ZONE
  , type VARCHAR(4)
  , status CHAR(1)
  , value VARCHAR(32)
  , value2 VARCHAR(32)
  , value3 VARCHAR(32)
  , int_value DECIMAL
  , int_value2 DECIMAL
  , int_value3 DECIMAL
  , owner_id VARCHAR(32)
  , object_id VARCHAR(32)
  , room_id VARCHAR(32)
  , room_number VARCHAR(64)
  , device_id VARCHAR(32)
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
    FROM session s LEFT JOIN room r ON r.room_id = s.owner_id
    LEFT JOIN device d ON d.owner_id = r.room_id;

    -- create a temp table to get the data
    CREATE TEMP TABLE session_init AS
      SELECT
            s.session_id
            , s.start_date
            , s.end_date
            , s.create_date
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
            , r.room_id
            , r.room_number
            , d.device_id
          FROM session s LEFT JOIN room r ON r.room_id = s.owner_id
          LEFT JOIN device d ON d.owner_id = r.room_id
          WHERE (
           ((pSessionId IS NULL) OR (s.session_id = pSessionId)) AND
           ((pType IS NULL) OR (s.type = pType)) AND
           ((pStatus IS NULL) OR (s.status = pStatus)) AND
           ((pValue IS NULL) OR (s.value = pValue)) AND
           ((pValue2 IS NULL) OR (s.value2 = pValue2)) AND
           ((pValue3 IS NULL) OR (s.value3 = pValue3)) AND
           ((pIntValue IS NULL) OR (s.int_value = pIntValue)) AND
           ((pIntValue2 IS NULL) OR (s.int_value2 = pIntValue2)) AND
           ((pIntValue3 IS NULL) OR (s.int_value3 = pIntValue3)) AND
           ((pOwnerId IS NULL) OR (s.owner_id = pOwnerId)) AND
           ((pObjectId IS NULL) OR (s.object_id = pObjectId)) AND
           ((pDeviceId IS NULL) OR (d.device_id = pDeviceId)) AND
           ((pRoomId IS NULL) OR (r.room_id = pRoomId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM session_init;
END;
$BODY$
LANGUAGE plpgsql;