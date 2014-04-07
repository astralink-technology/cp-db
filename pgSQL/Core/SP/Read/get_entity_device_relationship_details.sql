-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_entity_device_relationship_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_entity_device_relationship_details(
	pDeviceId varchar(32)
	, pOwnerId varchar(32)
	, pDeviceName varchar(32)
	, pDeviceCode varchar(32)
	, pDeviceStatus char(1)
	, pDeviceType char(1)
	, pDeviceType2 char(1)
	, pDeviceRelationshipName varchar(32)
	, pDeviceRelationshipPush char(1)
	, pDeviceRelationshipSms char(1)
	, pDeviceRelationshipToken varchar(128)
	, pDeviceRelationshipResolution varchar(16)
	, pDeviceRelationshipQuality varchar(16)
	, pDeviceRelationshipType char(1)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	device_id varchar(32)
	, device_name varchar(32)
	, device_code varchar(32)
	, device_status char(1)
	, device_type char(1)
	, device_type2 char(1)
	, description text
	, name varchar(64)
	, push char(1)
	, token varchar(128)
	, sms char(1)
	, quality varchar(16)
	, resolution varchar(16)
	, device_last_update timestamp without time zone
	, last_update timestamp without time zone
	, owner_id varchar(32)
	, device_relationship_value_id varchar(32)
	, device_relationship_id varchar(32)
	, total_rows integer
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
    FROM device d INNER JOIN
      device_relationship dr ON dr.device_id = d.device_id INNER JOIN
      device_relationship_value drv ON drv.device_relationship_id = dr.device_relationship_id WHERE
      (
        ((pDeviceId IS NULL) OR (pDeviceId = dr.device_id)) AND
        ((pOwnerId IS NULL) OR (pOwnerId = dr.owner_id)) AND
        ((pDeviceName IS NULL) OR (pDeviceName = d.name)) AND
        ((pDeviceCode IS NULL) OR (pDeviceCode = d.code)) AND
        ((pDeviceStatus IS NULL) OR (pDeviceStatus = d.status)) AND
        ((pDeviceType IS NULL) OR (pDeviceType = d.type)) AND
        ((pDeviceType2 IS NULL) OR (pDeviceType2 = d.type2)) AND
        ((pDeviceRelationshipName IS NULL) OR (pDeviceRelationshipName = drv.name)) AND
        ((pDeviceRelationshipPush IS NULL) OR (pDeviceRelationshipPush = drv.push)) AND
        ((pDeviceRelationshipSms IS NULL) OR (pDeviceRelationshipSms = drv.push)) AND
        ((pDeviceRelationshipToken IS NULL) OR (pDeviceRelationshipToken = drv.token)) AND
        ((pDeviceRelationshipResolution IS NULL) OR (pDeviceRelationshipResolution = drv.resolution)) AND
        ((pDeviceRelationshipQuality IS NULL) OR (pDeviceRelationshipQuality = drv.quality)) AND
        ((pDeviceRelationshipType IS NULL) OR (pDeviceRelationshipType = drv.type))
      );

    -- create a temp table to get the data
    CREATE TEMP TABLE entity_device_relationship_details_init AS
      SELECT
        d.device_id
        , d.name as device_name
        , d.code as device_code
        , d.status as device_status
        , d.type as device_type
        , d.type2 as device_type2
        , d.description as device_description
        , drv.name
        , drv.push
        , drv.token
        , drv.sms
        , drv.quality
        , drv.resolution
        , d.last_update as device_last_update
        , drv.last_update
        , dr.owner_id
        , drv.device_relationship_value_id
        , dr.device_relationship_id
      FROM device d INNER JOIN
      device_relationship dr ON dr.device_id = d.device_id INNER JOIN
      device_relationship_value drv ON drv.device_relationship_id = dr.device_relationship_id WHERE
      (
        ((pDeviceId IS NULL) OR (pDeviceId = dr.device_id)) AND
        ((pOwnerId IS NULL) OR (pOwnerId = dr.owner_id)) AND
        ((pDeviceName IS NULL) OR (pDeviceName = d.name)) AND
        ((pDeviceCode IS NULL) OR (pDeviceCode = d.code)) AND
        ((pDeviceStatus IS NULL) OR (pDeviceStatus = d.status)) AND
        ((pDeviceType IS NULL) OR (pDeviceType = d.type)) AND
        ((pDeviceType2 IS NULL) OR (pDeviceType2 = d.type2)) AND
        ((pDeviceRelationshipName IS NULL) OR (pDeviceRelationshipName = drv.name)) AND
        ((pDeviceRelationshipPush IS NULL) OR (pDeviceRelationshipPush = drv.push)) AND
        ((pDeviceRelationshipSms IS NULL) OR (pDeviceRelationshipSms = drv.push)) AND
        ((pDeviceRelationshipToken IS NULL) OR (pDeviceRelationshipToken = drv.token)) AND
        ((pDeviceRelationshipResolution IS NULL) OR (pDeviceRelationshipResolution = drv.resolution)) AND
        ((pDeviceRelationshipQuality IS NULL) OR (pDeviceRelationshipQuality = drv.quality)) AND
        ((pDeviceRelationshipType IS NULL) OR (pDeviceRelationshipType = drv.type))
      )
      ORDER BY d.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM entity_device_relationship_details_init;
END;
$BODY$
LANGUAGE plpgsql;
