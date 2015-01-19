-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_room_value' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_room_value(
        pRoomValueId varchar(32)
        , pName varchar(128)
        , pType varchar(4)
        , pStatus char(1)
        , pValue varchar(64)
        , pIntValue decimal
)
RETURNS BOOL AS
$BODY$
DECLARE
      oName varchar(128);
      oType varchar(4);
      oStatus char(1);
      oValue varchar(64);
      oIntValue decimal;

      nName varchar(128);
      nType varchar(4);
      nStatus char(1);
      nValue varchar(64);
      nIntValue decimal;
BEGIN
    -- Room Value ID is needed if not return
    IF pRoomValueId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            rv.name
            , rv.type
            , rv.status
            , rv.value
            , rv.int_value
        INTO STRICT
            oName
            , oType
            , oStatus
            , oValue
            , oIntValue
        FROM room_value rv WHERE
            rv.room_value_id = pRoomValueId;

        -- Start the updating process
        IF pName IS NULL THEN
            nName := oName;
        ELSEIF pName = '' THEN
            -- defaulted null
            nName := NULL;
        ELSE
            nName := pName;
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

        IF pIntValue IS NULL THEN
            nIntValue := oIntValue;
        ELSEIF pIntValue = '' THEN
            -- defaulted null
            nIntValue := NULL;
        ELSE
            nIntValue := pIntValue;
        END IF;

        -- start the update
        UPDATE
            room_value
        SET
            name = oName
            , type = oType
            , status = oStatus
            , value = oValue
            , int_value = oIntValue
        WHERE
            room_value_id = pRoomValueId;

        RETURN TRUE;

    END IF;
END;
$BODY$
LANGUAGE plpgsql;