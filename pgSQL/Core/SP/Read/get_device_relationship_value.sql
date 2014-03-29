-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS get_device_relationship_value(
	pDeviceRelationshipValueId varchar(32)
	, pName varchar(64)
	, pPush char(1)
	, pSms char(1)
	, pToken varchar(256)
	, pType char(1)
	, pResolution varchar(16)
	, pQuality varchar(16)
	, pDeviceRelationshipId varchar(32)
	, pPageSize integer
	, pSkipSize integer
);
-- Start function
CREATE FUNCTION get_device_relationship_value(
	pDeviceRelationshipValueId varchar(32)
	, pName varchar(64)
	, pPush char(1)
	, pSms char(1)
	, pToken varchar(256)
	, pType char(1)
	, pResolution varchar(16)
	, pQuality varchar(16)
	, pDeviceRelationshipId varchar(32)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	device_relationship_value_id varchar(32),
	name varchar(64),
	push char(1),
	sms char(1),
	token varchar(256),
	type char(1),
	resolution varchar(16),
	quality varchar(16),
	hash varchar(60),
	salt varchar(16),
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	device_relationship_id varchar(32),
	description text,
	total_rows integer
) AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM device_relationship_value drv WHERE (
        ((pDeviceRelationshipValueId IS NULL) OR (drv.device_relationship_value_id = pDeviceRelationshipValueId)) AND
        ((pName IS NULL) OR (drv.name = pName)) AND
        ((pPush IS NULL) OR (drv.push = pPush)) AND
        ((pSms IS NULL) OR (drv.sms = pSms)) AND
        ((pToken IS NULL) OR (drv.token = pToken)) AND
        ((pType IS NULL) OR (drv.type = pType)) AND
        ((pResolution IS NULL) OR (drv.resolution = pResolution)) AND
        ((pQuality IS NULL) OR (drv.quality = pQuality)) AND
        ((pDeviceRelationshipId IS NULL) OR (drv.device_relationship_id = pDeviceRelationshipId))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE device_relationship_value_init AS
      SELECT
        drv.device_relationship_value_id
        , drv.name
        , drv.push
        , drv.sms
        , drv.token
        , drv.type
        , drv.resolution
        , drv.quality
        , drv.hash
        , drv.salt
        , drv.create_date
        , drv.last_update
        , drv.device_relationship_id
        , drv.description
      FROM device_relationship_value drv WHERE (
        ((pDeviceRelationshipValueId IS NULL) OR (drv.device_relationship_value_id = pDeviceRelationshipValueId)) AND
        ((pName IS NULL) OR (drv.name = pName)) AND
        ((pPush IS NULL) OR (drv.push = pPush)) AND
        ((pSms IS NULL) OR (drv.sms = pSms)) AND
        ((pToken IS NULL) OR (drv.token = pToken)) AND
        ((pType IS NULL) OR (drv.type = pType)) AND
        ((pResolution IS NULL) OR (drv.resolution = pResolution)) AND
        ((pQuality IS NULL) OR (drv.quality = pQuality)) AND
        ((pDeviceRelationshipId IS NULL) OR (drv.device_relationship_id = pDeviceRelationshipId))
    )
    ORDER BY drv.create_date
    LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM device_relationship_value_init;

END;
$BODY$
LANGUAGE plpgsql;

