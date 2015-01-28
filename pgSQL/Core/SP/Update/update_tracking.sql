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
      , pOwnerId varchar(32)
  )
  RETURNS BOOL AS
  $BODY$
  DECLARE
      oName text;
      oIpAddress text;
      oCountry varchar(256);
      oCountryCode varchar(8);
      oType varchar(4);
      oOwnerId varchar(32);

      nName text;
      nIpAddress text;
      nCountry varchar(256);
      nCountryCode varchar(8);
      nType varchar(4);
      nOwnerId varchar(32);
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
              , t.owner_id
          INTO STRICT
              oName
              , oIpAddress
              , oCountry
              , oCountryCode
              , oType
              , oOwnerId
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

          IF pOwnerId IS NULL THEN
              nOwnerId := oOwnerId;
          ELSEIF pOwnerId = '' THEN
              nOwnerId := NULL;
          ELSE
              nOwnerId := oOwnerId;
          END IF;

          -- start the update
          UPDATE
              trackin
          SET
              name = nName
              , ip_address = nIpAddress
              , country = nCountry
              , country_code = nCountryCode
              , type = nType
              , owner_id = nOwnerId
          WHERE
              tracking_id = pTrackingId;

          RETURN TRUE;

      END IF;
  END;
  $BODY$
  LANGUAGE plpgsql;