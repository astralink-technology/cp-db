  -- Drop function
  DO $$
  DECLARE fname text;
  BEGIN
  FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_address' LOOP
    EXECUTE 'DROP FUNCTION ' || fname;
  END loop;
  RAISE INFO 'FUNCTION % DROPPED', fname;
  END$$;
  -- Start function
  CREATE FUNCTION add_address(
      pAddressId varchar(32)
      , pApartment varchar(64)
      , pRoadName text
      , pRoadName2 text
      , pSuite varchar(32)
      , pZip varchar(16)
      , pCountry varchar(128)
      , pProvince varchar(128)
      , pState varchar(128)
      , pCity varchar(128)
      , pType char (1)
      , pStatus char(1)
      , pLongitude decimal
      , pLatitude decimal
      , pCreateDate timestamp without time zone
      , pLastUpdate timestamp without time zone
      , pOwnerId varchar(32)
  )
  RETURNS varchar(32) AS
  $BODY$
  BEGIN
      INSERT INTO address (
        address_id
        , apartment
        , road_name
        , road_name2
        , suite
        , zip
        , country
        , province
        , state
        , city
        , type
        , status
        , longitude
        , latitude
        , create_date
        , last_update
        , owner_id
      ) VALUES(
        pAddressId
        , pApartment
        , pRoadName
        , pRoadName2
        , pSuite
        , pZip
        , pCountry
        , pProvince
        , pState
        , pCity
        , pType
        , pStatus
        , pLongitude
        , pLatitude
        , pCreateDate
        , pLastUpdate
        , pOwnerId
      );
      RETURN pAddressId;
  END;
  $BODY$
  LANGUAGE plpgsql;
