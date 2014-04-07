  -- Drop function
  DO $$
  DECLARE fname text;
  BEGIN
  FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_device_relationship_value' LOOP
    EXECUTE 'DROP FUNCTION ' || fname;
  END loop;
  RAISE INFO 'FUNCTION % DROPPED', fname;
  END$$;
  -- Start function
  CREATE FUNCTION update_device_relationship_value(
    pDeviceRelationshipValueId varchar(32)
    , pName varchar(64)
    , pPush char(1)
    , pSms char(1)
    , pToken varchar(256)
    , pType char(1)
    , pResolution varchar(16)
    , pQuality varchar(16)
    , pHash varchar(60)
    , pSalt varchar(16)
    , pLastUpdate timestamp without time zone
    , pDeviceRelationshipId varchar(32)
    , pDescription text
  )
  RETURNS BOOL AS
  $BODY$
  DECLARE
      nName varchar(64);
      nPush char(1);
      nSms char(1);
      nToken varchar(256);
      nType char(1);
      nResolution varchar(16);
      nQuality varchar(16);
      nHash varchar(60);
      nSalt varchar(16);
      nLastUpdate timestamp without time zone;
      nDeviceRelationshipId varchar(32);
      nDescription text;

      oName varchar(64);
      oPush char(1);
      oSms char(1);
      oToken varchar(256);
      oType char(1);
      oResolution varchar(16);
      oQuality varchar(16);
      oHash varchar(60);
      oSalt varchar(16);
      oLastUpdate timestamp without time zone;
      oDeviceRelationshipId varchar(32);
      oDescription text;

  BEGIN
      -- ID is needed if not return
      IF pDeviceRelationshipValueId IS NULL THEN
          RETURN FALSE;
      ELSE
          -- select the variables into the old variables
          SELECT
            drv.push
            , drv.name
            , drv.sms
            , drv.token
            , drv.type
            , drv.resolution
            , drv.quality
            , drv.hash
            , drv.salt
            , drv.last_update
            , drv.device_relationship_id
            , drv.description
            , drv.app_version
            , drv.firmware_version
          INTO STRICT
            oPush
            , oName
            , oSms
            , oToken
            , oType
            , oResolution
            , oQuality
            , oHash
            , oSalt
            , oLastUpdate
            , oDeviceRelationshipId
            , oDescription
          FROM device_relationship_value drv WHERE
              drv.device_relationship_value_id = pDeviceRelationshipValueId;

          -- Start the updating process
          IF pName IS NULL THEN
              nName := oName;
          ELSEIF pName = '' THEN
              nName := NULL;
          ELSE
              nName := pName;
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

          IF pDeviceRelationshipId IS NULL THEN
              nDeviceRelationshipId := oDeviceRelationshipId;
          ELSEIF pDeviceRelationshipId = '' THEN
              nDeviceRelationshipId := NULL;
          ELSE
              nDeviceRelationshipId := pDeviceRelationshipId;
          END IF;


          IF pDescription IS NULL THEN
              nDescription := oDescription;
          ELSEIF pDescription = '' THEN
              nDescription := NULL;
          ELSE
              nDescription := pDescription;
          END IF;

          -- start the update
          UPDATE
              device_relationship_value
          SET
            push = nPush
            , name = nName
            , sms = nSms
            , token = nToken
            , type = nType
            , resolution = nResolution
            , quality = nQuality
            , hash = nHash
            , salt = nSalt
            , last_update = nLastUpdate
            , description = nDescription
            , device_relationship_id = nDeviceRelationshipId
           WHERE (
            device_relationship_value_id = pDeviceRelationshipValueId
          );

          RETURN TRUE;

      END IF;
  END;
  $BODY$
  LANGUAGE plpgsql;

