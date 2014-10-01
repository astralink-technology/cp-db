-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_address' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_address(
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
    , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    nApartment varchar(64);
    nRoadName text;
    nRoadName2 text;
    nSuite varchar(32);
    nZip varchar(16);
    nCountry varchar(128);
    nProvince varchar(128);
    nState varchar(128);
    nCity varchar(128);
    nType char (1);
    nStatus char(1);
    nLongitude decimal;
    nLatitude decimal;
    nLastUpdate timestamp without time zone;

    oApartment varchar(64);
    oRoadName text;
    oRoadName2 text;
    oSuite varchar(32);
    oZip varchar(16);
    oCountry varchar(128);
    oProvince varchar(128);
    oState varchar(128);
    oCity varchar(128);
    oType char (1);
    oStatus char(1);
    oLongitude decimal;
    oLatitude decimal;
    oLastUpdate timestamp without time zone;
BEGIN
    -- Phone ID is needed if not return
    IF pAddressId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
          a.apartment
          , a.road_name
          , a.road_name2
          , a.suite
          , a.zip
          , a.country
          , a.province
          , a.state
          , a.city
          , a.type
          , a.status
          , a.longitude
          , a.latitude
          , a.last_update
        INTO STRICT
          oApartment
          , oRoadName
          , oRoadName2
          , oSuite
          , oZip
          , oCountry
          , oProvince
          , oState
          , oCity
          , oType
          , oStatus
          , oLongitude
          , oLatitude
          , oLastUpdate
        FROM address a WHERE
            a.address_id = pAddressId;
        
        -- Start the updating process
        IF pApartment IS NULL THEN 
            nApartment := oApartment;
        ELSEIF pApartment = '' THEN
            nApartment := NULL;
        ELSE
            nApartment := pApartment;
        END IF;
        
        IF pRoadName IS NULL THEN
            nRoadName := oRoadName;
        ELSEIF pRoadName = '' THEN
            nRoadName := NULL;
        ELSE
            nRoadName := pRoadName;
        END IF;
        
        IF pRoadName2 IS NULL THEN
            nRoadName2 := oRoadName2;
        ELSEIF pRoadName2 = '' THEN
            nRoadName2 := NULL;
        ELSE
            nRoadName2 := pRoadName2;
        END IF;

        IF pSuite IS NULL THEN 
            nSuite := oSuite;
        ELSEIF pSuite = '' THEN  
            nSuite := NULL;
        ELSE
            nSuite := pSuite;
        END IF;

        IF pZip IS NULL THEN 
            nZip := oZip;
        ELSEIF pZip = '' THEN  
            nZip := NULL;
        ELSE
            nZip := pZip;
        END IF;

        IF pCountry IS NULL THEN
            nCountry := oCountry;
        ELSEIF pCountry = '' THEN
            nCountry := NULL;
        ELSE
            nCountry := pCountry;
        END IF;

        IF pProvince IS NULL THEN
            nProvince := oProvince;
        ELSEIF pProvince = '' THEN
            nProvince := NULL;
        ELSE
            nProvince := pProvince;
        END IF;

        IF pState IS NULL THEN
            nState := oState;
        ELSEIF pState = '' THEN
            nState := NULL;
        ELSE
            nState := pState;
        END IF;

        IF pCity IS NULL THEN
            nCity := oCity;
        ELSEIF pCity = '' THEN
            nCity := NULL;
        ELSE
            nCity := pCity;
        END IF;

        IF pType IS NULL THEN
            nType := oType;
        ELSEIF pType = '' THEN
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pStatus IS NULL THEN
            nStatus := oStatus;
        ELSEIF pStatus = '' THEN
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;

        IF pLongitude IS NULL THEN
            nLongitude := oLongitude;
        ELSEIF pLongitude = '' THEN
            nLongitude := NULL;
        ELSE
            nLongitude := pLongitude;
        END IF;

        IF pLatitude IS NULL THEN
            nLatitude := oLatitude;
        ELSEIF pLatitude = '' THEN
            nLatitude := NULL;
        ELSE
            nLatitude := pLatitude;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            address
        SET
          a.apartment = nApartment
          , a.road_name = nRoadName
          , a.road_name2 = nRoadName2
          , a.suite = nSuite
          , a.zip = nZip
          , a.country = nCountry
          , a.province = nProvince
          , a.state = nState
          , a.city = nCity
          , a.type = nType
          , a.status = nStatus
          , a.longitude = nLongitude
          , a.latitude = nLatitude
          , a.last_update = nLastUpdate
        WHERE 
            address_id = pAddressId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
