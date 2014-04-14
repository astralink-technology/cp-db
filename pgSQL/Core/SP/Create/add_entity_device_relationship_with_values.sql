-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_entity_device_relationship_with_values' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_entity_device_relationship_with_values(
	pDeviceId varchar(32)
	, pDeviceName varchar(32)
	, pDeviceCode varchar(32)
	, pDeviceStatus char(1)
	, pDeviceType char(1)
	, pDeviceType2 char(1)
	, pDeviceDescription text
	, pDeviceCreateDate timestamp without time zone
	, pDeviceLastUpdate timestamp without time zone
	, pDeviceOwnerId varchar(32)
  , pOwnerId varchar(32)

	, pDeviceRelationshipId varchar(32)
	, pDeviceRelationshipLastUpdate timestamp without time zone
	, pDeviceRelationshipCreateDate timestamp without time zone

	, pDeviceRelationshipValueId varchar(32)
	, pName varchar(64)
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
	, pDescription text
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
    , pDeviceName
    , pDeviceCode
    , pDeviceStatus
    , pDeviceType
    , pDeviceType2
    , pDeviceDescription
    , pDeviceCreateDate
    , pDeviceLastUpdate
    , pDeviceOwnerId
    );


    INSERT INTO device_relationship(
      device_relationship_id
      , device_id
      , owner_id
      , last_update
      , create_date
    ) VALUES(
	    pDeviceRelationshipId
      , pDeviceId
      , pOwnerId
      , pDeviceRelationshipLastUpdate
      , pDeviceRelationshipCreateDate
    );

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
    );
    RETURN pDeviceRelationshipId;
END;
$BODY$
LANGUAGE plpgsql;
