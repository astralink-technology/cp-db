-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_device_relationship(
pDeviceRelationshipId varchar(32)
  , pRelationshipName varchar(64)
	, pDeviceId varchar(32)
	, pDevice2Id varchar(32)
	, pEntityId varchar(32)
	, pLastUpdate timestamp without time zone
	, pCreateDate timestamp without time zone
);
-- Start function
CREATE FUNCTION add_device_relationship(
	pDeviceRelationshipId varchar(32) 
	, pDeviceId varchar(32)
	, pOwnerId varchar(32)
	, pLastUpdate timestamp without time zone
	, pCreateDate timestamp without time zone
	, pAppName varchar(64)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO device_relationship(
      device_relationship_id
      , device_id
      , owner_id
      , last_update
      , create_date
      , app_name
    ) VALUES(
	pDeviceRelationshipId
      , pDeviceId
      , pOwnerId
      , pLastUpdate
      , pCreateDate
	, pAppName
    );
    RETURN pDeviceRelationshipId;
END;
$BODY$
LANGUAGE plpgsql;
