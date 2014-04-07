-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_device_value(
	pDeviceValueId varchar(32)
	, pPush char(1)
	, pSms char(1)
	, pToken varchar(256)
	, pType varchar(32)
	, pResolution varchar(16)
	, pQuality varchar(16)
	, pHash varchar(60)
	, pSalt varchar(16)
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
	, pDeviceId varchar(32)
	, pDescription text
);
-- Start function
CREATE FUNCTION add_device_value(
	pDeviceValueId varchar(32)
	, pPush char(1)
	, pSms char(1)
	, pToken varchar(256)
	, pType varchar(32)
	, pResolution varchar(16)
	, pQuality varchar(16)
	, pHash varchar(60)
	, pSalt varchar(16)
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
	, pDeviceId varchar(32)
	, pDescription text
	, pLocationName varchar(64)
	, pLatitude decimal
	, pLongitude decimal
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO device_value(
        device_value_id
        , push
        , sms
        , token
        , type
        , resolution
	      , quality
        , hash
        , salt
        , create_date
        , last_update
        , device_id
	, description
	, location_name
	, latitude
	, longitude
    ) VALUES(
        pDeviceValueId
        , pPush
        , pSms
        , pToken
        , pType
        , pResolution
        , pQuality
        , pHash
        , pSalt
        , pCreateDate
        , pLastUpdate
        , pDeviceId
	      , pDescription
	, pLocationName
	, pLatitude
	, pLongitude
    );
    RETURN pDeviceId;
END;
$BODY$
LANGUAGE plpgsql;
