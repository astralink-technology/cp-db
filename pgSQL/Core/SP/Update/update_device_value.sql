-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_device_value' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_device_value(
	pDeviceValueId varchar(32)
	, pPush char(1)
	, pSms char(1)
	, pToken varchar(256)
	, pType varchar(32)
	, pResolution varchar(16)
	, pQuality varchar(16)
	, pHash varchar(60)
	, pSalt varchar(16)
	, pLastUpdate timestamp without time zone
	, pDeviceId varchar(32)
	, pDescription varchar(32)
	, pLocationName varchar(64)
	, pLatitude decimal
	, pLongitude decimal
	, pAppVersion varchar(16)
	, pFirmwareVersion varchar(16)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    nDeviceValueId varchar(32);
    nPush char(1);
    nSms char(1);
    nToken varchar(256);
    nType varchar(32);
    nResolution varchar(16);
    nQuality varchar(16);
    nHash varchar(60);
    nSalt varchar(16);
    nLastUpdate timestamp without time zone;
    nDeviceId varchar(32);
    nDescription varchar(32);
    nLocationName varchar(64);
    nLatitude decimal;
    nLongitude decimal;
	  nAppVersion varchar(16);
	  nFirmwareVersion varchar(16);

    oDeviceValueId varchar(32);
    oPush char(1);
    oSms char(1);
    oToken varchar(256);
    oType varchar(32);
    oResolution varchar(16);
    oQuality varchar(16);
    oHash varchar(60);
    oSalt varchar(16);
    oLastUpdate timestamp without time zone;
    oDeviceId varchar(32);
    oDescription varchar(32);
    oLocationName varchar(64);
    oLatitude decimal;
    oLongitude decimal;
	  oAppVersion varchar(16);
	  oFirmwareVersion varchar(16);

BEGIN
    -- ID is needed if not return
    IF pDeviceId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
          dv.push
          , dv.sms
          , dv.token
          , dv.type
          , dv.resolution
          , dv.quality
          , dv.hash
          , dv.salt
          , dv.last_update
          , dv.device_id
          , dv.description
          , dv.location_name
          , dv.latitude
          , dv.longitude
          , dv.app_vesion
          , dv.firmware_version
        INTO STRICT
          oPush
          , oSms
          , oToken
          , oType
          , oResolution
          , oQuality
          , oHash
          , oSalt
          , oLastUpdate
          , oDeviceId
          , oDescription
          , oLocationName
          , oLatitude
          , oLongitude
          , oAppVersion
          , oFirmwareVersion
        FROM device_value dv WHERE
            dv.device_value_id = pDeviceValueId or dv.device_id = pDeviceId;

        -- Start the updating process
        IF pDeviceValueId IS NULL THEN 
            nDeviceValueId := oDeviceValueId;
        ELSEIF pDeviceValueId = '' THEN
            nDeviceValueId := NULL;
        ELSE
            nDeviceValueId := pDeviceValueId;
        END IF;

        IF pPush IS NULL THEN 
            nPush := oPush;
        ELSEIF pPush = '' THEN
            nPush := NULL;
        ELSE
            nPush := pPush;
        END IF;

        IF pSms IS NULL THEN 
            nSms := oSms;
        ELSEIF pSms = '' THEN
            nSms := NULL;
        ELSE
            nSms := pSms;
        END IF;

        IF pToken IS NULL THEN 
            nToken := oToken;
        ELSEIF pToken = '' THEN
            nToken := NULL;
        ELSE
            nToken := pToken;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pType = '' THEN
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pResolution IS NULL THEN 
            nResolution := oResolution;
        ELSEIF pResolution = '' THEN
            nResolution := NULL;
        ELSE
            nResolution := pResolution;
        END IF;

        IF pQuality IS NULL THEN 
            nQuality := nQuality;
        ELSEIF pQuality = '' THEN
            nQuality := NULL;
        ELSE
            nQuality := pQuality;
        END IF;

        IF pHash IS NULL THEN
            nHash := oHash;
        ELSEIF pHash = '' THEN
            nHash := NULL;
        ELSE
            nHash := pHash;
        END IF;

        IF pSalt IS NULL THEN 
            nSalt := oSalt;
        ELSEIF pSalt = '' THEN
            nSalt := NULL;
        ELSE
            nSalt := pSalt;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        IF pDeviceId IS NULL THEN 
            nDeviceId := oDeviceId;
        ELSEIF pDeviceId = '' THEN
            nDeviceId := NULL;
        ELSE
            nDeviceId := pDeviceId;
        END IF;


        IF pDescription IS NULL THEN 
            nDescription := oDescription;
        ELSEIF pDescription = '' THEN
            nDescription := NULL;
        ELSE
            nDescription := pDescription;
        END IF;

        IF pLatitude IS NULL THEN 
            nLatitude := oLatitude;
        ELSEIF pLatitude = '' THEN
            nLatitude := NULL;
        ELSE
            nLatitude := pLatitude;
        END IF;

        IF pLocationName IS NULL THEN 
            nLocationName := oLocationName;
        ELSEIF pLocationName = '' THEN
            nLocationName := NULL;
        ELSE
            nLocationName := pLocationName;
        END IF;

        IF pLongitude IS NULL THEN 
            nLongitude := oLongitude;
        ELSEIF pLongitude = '' THEN
            nLongitude := NULL;
        ELSE
            nLongitude := pLongitude;
        END IF;

        IF pAppVersion IS NULL THEN
            nAppVersion := oAppVersion;
        ELSEIF pAppVersion = '' THEN
            nAppVersion := NULL;
        ELSE
            nAppVersion := pAppVersion;
        END IF;
        
        IF pFirmwareVersion IS NULL THEN
            nFirmwareVersion := oFirmwareVersion;
        ELSEIF pFirmwareVersion = '' THEN
            nFirmwareVersion := NULL;
        ELSE
            nFirmwareVersion := pFirmwareVersion;
        END IF;


        -- start the update
        UPDATE 
            device_value
        SET
          push = nPush
          , sms = nSms
          , token = nToken
          , type = nType
          , resolution = nResolution
          , quality = nQuality
          , hash = nHash
          , salt = nSalt
          , last_update = nLastUpdate
          , description = nDescription
          , location_name = nLocationName
          , latitude = nLatitude
          , longitude = nLongitude
          , app_version = nAppVersion
          , firmware_version = nFirmwareVersion
         WHERE (
          ((pDeviceId IS NULL) OR (device_id = pDeviceId)) AND
          ((device_value_id = pDeviceValueId)) -- device value ID is required
        );

        RETURN TRUE;

    END IF;
END;
$BODY$
LANGUAGE plpgsql;

