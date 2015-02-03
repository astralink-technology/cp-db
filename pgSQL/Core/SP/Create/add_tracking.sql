  -- Drop function
  DO $$
  DECLARE fname text;
  BEGIN
  FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_tracking' LOOP
    EXECUTE 'DROP FUNCTION ' || fname;
  END loop;
  RAISE INFO 'FUNCTION % DROPPED', fname;
  END$$;
  -- Start function
  CREATE FUNCTION add_tracking(
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
      , pCreateDate timestamp without time zone
      , pOwnerId varchar(32)
      , pParameters text
      , pMethod varchar(32)
  )
  RETURNS varchar(32) AS
  $BODY$
  BEGIN
      INSERT INTO tracking (
        tracking_id
        , name
        , ip_address
        , country
        , country_code
        , type
        , operating_system
        , operating_system_version
        , user_agent
        , user_agent_version
        , device
        , extra_data
        , create_date
        , owner_id
        , parameters
        , method
      ) VALUES(
        pTrackingId
        , pName
        , pIpAddress
        , pCountry
        , pCountryCode
        , pType
        , pOperatingSystem
        , pOperatingSystemVersion
        , pUserAgent
        , pUserAgentVersion
        , pDevice
        , pExtraData
        , pCreateDate
        , pOwnerId
        , pParameters
        , pMethod
      );
      RETURN pTrackingId;
  END;
  $BODY$
  LANGUAGE plpgsql;
