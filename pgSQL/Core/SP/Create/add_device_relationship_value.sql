-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_device_relationship_value(
	pDeviceRelationshipValueId varchar(32)
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
	, pDeviceRelationshipId varchar(32)
	, pDescription text
);
-- Start function
CREATE FUNCTION add_device_relationship_value(
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
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
	, pDeviceRelationshipId varchar(32)
	, pDescription text
	, pAppVersion varchar(16)
	, pFirmwareVersion varchar(16)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO device_relationship_value(
        device_relationship_value_id
        , name
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
        , device_relationship_id
	, description
	, app_version
	, firmware_version
    ) VALUES(
        pDeviceRelationshipValueId
        , pName
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
        , pDeviceRelationshipId
	      , pDescription
	, pAppVersion
	, pFirmwareVersion
    );
    RETURN pDeviceRelationshipId;
END;
$BODY$
LANGUAGE plpgsql;
