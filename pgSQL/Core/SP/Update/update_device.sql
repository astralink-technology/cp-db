-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_device' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_device(
    pDeviceId varchar(32)
    , pName varchar(32)
    , pCode varchar(32)
    , pStatus char(1)
    , pType char(1)
    , pType2 char(1)
    , pDescription text
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    nName varchar(32);
    nCode varchar(32);
    nStatus char(1);
    nType char(1);
    nType2 char(1);
    nDescription text;
    nLastUpdate timestamp without time zone;
    nOwnerId varchar(32);

    oName varchar(32);
    oCode varchar(32);
    oStatus char(1);
    oType char(1);
    oType2 char(1);
    oDescription text;
    oLastUpdate timestamp without time zone;
    oOwnerId varchar(32);
BEGIN
    -- ID is needed if not return
    IF pDeviceId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            d.name
            , d.code
            , d.status
            , d.type
            , d.type2
            , d.description
            , d.last_update
            , d.owner_id
        INTO STRICT
            oName
            , oCode
            , oStatus
            , oType
            , oType2
            , oDescription
            , oLastUpdate
            , oOwnerId
        FROM device d WHERE 
            d.device_id = pDeviceId;

        -- Start the updating process
        IF pName IS NULL THEN 
            nName := oName;
        ELSEIF pName = '' THEN
            nName := NULL;
        ELSE
            nName := pName;
        END IF;

        IF pCode IS NULL THEN 
            nCode := oCode;
        ELSEIF pCode = '' THEN
            nCode := NULL;
        ELSE
            nCode := pCode;
        END IF;

        IF pStatus IS NULL THEN 
            nStatus := oStatus;
        ELSEIF pStatus = '' THEN
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pType = '' THEN
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pDescription IS NULL THEN
            nDescription := oDescription;
        ELSEIF pDescription = '' THEN
            nDescription := NULL;
        ELSE
            nDescription := pDescription;
        END IF;

        IF pType2 IS NULL THEN 
            nType2 := oType2;
        ELSEIF pType2 = '' THEN
            nType2 := NULL;
        ELSE
            nType2 := pType2;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        IF pOwnerId IS NULL THEN 
            nOwnerId := oOwnerId;
        ELSEIF pOwnerId = '' THEN
            nOwnerId := NULL;
        ELSE
            nOwnerId := pOwnerId;
        END IF;


        -- start the update
        UPDATE 
            device
        SET 
            name = nName
            , code = nCode
            , status = nStatus
            , type = nType
            , type2 = nType2
            , description = nDescription
            , last_update = nLastUpdate
            , owner_id = nOwnerId
        WHERE 
            device_id = pDeviceId;

        RETURN TRUE;

    END IF;
END;
$BODY$
LANGUAGE plpgsql;

