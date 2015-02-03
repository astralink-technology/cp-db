-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_tracking' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
  -- Start function
  CREATE FUNCTION update_tracking(
      pTrackingId varchar(32)
      , pName text
      , pIpAddress text
      , pCountry varchar(256)
      , pCountryCode varchar(8)
      , pType varchar(4)
      , pOperatingSystem varchar(256)
      , pOperatingSystemVersion varchar(256)
      , pUserAgent varchar(256)
      , pUserAgentVersion varchar(256)
      , pDevice varchar(256)
      , pExtraData text
      , pOwnerId varchar(32)
      , pParameters text
      , pMethod varchar(32)
  )
  RETURNS BOOL AS
  $BODY$
  DECLARE
      oName text;
      oIpAddress text;
      oCountry varchar(256);
      oCountryCode varchar(8);
      oType varchar(4);
      oOperatingSystem varchar(256);
      oOperatingSystemVersion varchar(256);
      oUserAgent varchar(256);
      oUserAgentVersion varchar(256);
      oDevice varchar(256);
      oExtraData text;
      oOwnerId varchar(32);
      oParameters text;
      oMethod varchar(32);

      nName text;
      nIpAddress text;
      nCountry varchar(256);
      nCountryCode varchar(8);
      nType varchar(4);
      nOperatingSystem varchar(256);
      nOperatingSystemVersion varchar(256);
      nUserAgent varchar(256);
      nUserAgentVersion varchar(256);
      nDevice varchar(256);
      nExtraData text;
      nOwnerId varchar(32);
      nParameters text;
      nMethod varchar(32);
  BEGIN
      -- ID is needed if not return
      IF pTrackingId IS NULL THEN
          RETURN FALSE;
      ELSE
          -- select the variables into the old variables
          SELECT
            t.name
            , t.ip_address
            , t.country
            , t.country_code
            , t.type
            , t.operating_system
            , t.operating_system_version
            , t.user_agent
            , t.user_agent_version
            , t.device
            , t.extra_data
            , t.owner_id
            , t.parameters
            , t.method
          INTO STRICT
            oName
            , oIpAddress
            , oCountry
            , oCountryCode
            , oType
            , oOperatingSystem
            , oOperatingSystemVersion
            , oUserAgent
            , oUserAgentVersion
            , oDevice
            , oExtraData
            , oOwnerId
            , oParameters
            , oMethod
          FROM tracking t WHERE
              t.tracking_id = pTrackingId;

          -- Start the updating process
          IF pName IS NULL THEN
              nName := oName;
          ELSEIF pName = '' THEN
              nName := NULL;
          ELSE
              nName := pName;
          END IF;

          IF pIpAddress IS NULL THEN
              nIpAddress := oIpAddress;
          ELSEIF pIpAddress = '' THEN
              nIpAddress := NULL;
          ELSE
              nIpAddress := oIpAddress;
          END IF;

          IF pCountry IS NULL THEN
              nCountry := oCountry;
          ELSEIF pCountry = '' THEN
              nCountry := NULL;
          ELSE
              nCountry := oCountry;
          END IF;

          IF pCountryCode IS NULL THEN
              nCountryCode := oCountryCode;
          ELSEIF pCountryCode = '' THEN
              nCountryCode := NULL;
          ELSE
              nCountryCode := oCountryCode;
          END IF;

          IF pType IS NULL THEN
              nType := oType;
          ELSEIF pType = '' THEN
              nType := NULL;
          ELSE
              nType := oType;
          END IF;

          IF pOperatingSystem IS NULL THEN
              nOperatingSystem := oOperatingSystem;
          ELSEIF pOperatingSystem = '' THEN
              nOperatingSystem := NULL;
          ELSE
              nOperatingSystem := oOperatingSystem;
          END IF;

          IF pOperatingSystemVersion IS NULL THEN
              nOperatingSystemVersion := oOperatingSystemVersion;
          ELSEIF pOperatingSystemVersion = '' THEN
              nOperatingSystemVersion := NULL;
          ELSE
              nOperatingSystemVersion := oOperatingSystemVersion;
          END IF;

          IF pUserAgent IS NULL THEN
              nUserAgent := oUserAgent;
          ELSEIF pUserAgent = '' THEN
              nUserAgent := NULL;
          ELSE
              nUserAgent := oUserAgent;
          END IF;

          IF pUserAgentVersion IS NULL THEN
              nUserAgentVersion := oUserAgentVersion;
          ELSEIF pUserAgentVersion = '' THEN
              nUserAgentVersion := NULL;
          ELSE
              nUserAgentVersion := oUserAgentVersion;
          END IF;

          IF pDevice IS NULL THEN
              nDevice := oDevice;
          ELSEIF pDevice = '' THEN
              nDevice := NULL;
          ELSE
              nDevice := oDevice;
          END IF;

          IF pExtraData IS NULL THEN
              nExtraData := oExtraData;
          ELSEIF pExtraData = '' THEN
              nExtraData := NULL;
          ELSE
              nExtraData := oExtraData;
          END IF;

          IF pOwnerId IS NULL THEN
              nOwnerId := oOwnerId;
          ELSEIF pOwnerId = '' THEN
              nOwnerId := NULL;
          ELSE
              nOwnerId := oOwnerId;
          END IF;

          IF pMethod IS NULL THEN
              nMethod := oMethod;
          ELSEIF pMethod = '' THEN
              nMethod := NULL;
          ELSE
              nMethod := oMethod;
          END IF;

          IF pParameters IS NULL THEN
              nParameters := oParameters;
          ELSEIF pParameters = '' THEN
              nParameters := NULL;
          ELSE
              nParameters := oParameters;
          END IF;

          -- start the update
          UPDATE
              tracking
          SET
              name = nName
              , ip_address = nName
              , country = nCountry
              , country_code = nCountryCOde
              , type = nType
              , operating_system = nOperatingSystem
              , operating_system_version = nOperatingSystemVersion
              , user_agent = nUserAgent
              , user_agent_version = nUserAgentVersion
              , device = nDevice
              , extra_data = nExtraData
              , owner_id = nOwnerId
              , method = nMethod
              , parameters = nParameters
          WHERE
              tracking_id = pTrackingId;

          RETURN TRUE;

      END IF;
  END;
  $BODY$
  LANGUAGE plpgsql;