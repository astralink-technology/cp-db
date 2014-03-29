-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_device_with_values(
	pDeviceId varchar(32)
	, pName varchar(32) 
	, pCode varchar(32)
	, pStatus char(1)
	, pType char(1)
	, pType2 char(1)
	, pDescription text
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
	, pEntityId varchar(32)
	, pDeviceValueId varchar(32)
	, pPush char(1)
	, pSms char(1)
	, pToken varchar(128)
	, pDeviceValueType varchar(32)
	, pResolution varchar(16)
	, pQuality varchar(16)
	, pHash varchar(60)
	, pSalt varchar(16)
	, pDeviceValueCreateDate timestamp without time zone
	, pDeviceValueLastUpdate timestamp without time zone
	, pDeviceValueDescription text
);
-- Start function
CREATE FUNCTION add_device_with_values(
	pDeviceId varchar(32)
	, pName varchar(32) 
	, pCode varchar(32)
	, pStatus char(1)
	, pType char(1)
	, pType2 char(1)
	, pDescription text
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
	, pOwnerId varchar(32)
	, pDeviceValueId varchar(32)
	, pPush char(1)
	, pSms char(1)
	, pToken varchar(128)
	, pDeviceValueType varchar(32)
	, pResolution varchar(16)
	, pQuality varchar(16)
	, pHash varchar(60)
	, pSalt varchar(16)
	, pDeviceValueCreateDate timestamp without time zone
	, pDeviceValueLastUpdate timestamp without time zone
	, pDeviceValueDescription text
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO device(
      device_id
      , name
      , code
      , status
      , type
      , type2
      , description
      , create_date
      , last_update
      , owner_id
    ) VALUES(
      pDeviceId
      , pName
      , pCode
      , pStatus
      , pType
      , pType2
      , pDescription
      , pCreateDate
      , pLastUpdate
      , pOwnerId
    );

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
    ) VALUES(
        pDeviceValueId
        , pPush
        , pSms
        , pToken
        , pDeviceValueType
        , pResolution
        , pQuality
        , pHash
        , pSalt
        , pDeviceValueCreateDate
        , pDeviceValueLastUpdate
        , pDeviceId
        , pDeviceValueDescription
    );
    RETURN pDeviceId;
END;
$BODY$
LANGUAGE plpgsql;
