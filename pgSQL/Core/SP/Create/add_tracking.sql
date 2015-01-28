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
      , pCreateDate timestamp without time zone
      , pOwnerId varchar(32)
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
        , create_date
        , owner_id
      ) VALUES(
        pTrackingId
        , pName
        , pIpAddress
        , pCountry
        , pCountryCode
        , pType
        , pCreateDate
        , pOwnerId
      );
      RETURN pTrackingId;
  END;
  $BODY$
  LANGUAGE plpgsql;
