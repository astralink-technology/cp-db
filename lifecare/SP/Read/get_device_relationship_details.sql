-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_device_relationship_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_device_relationship_details(
	pDeviceRelationshipId varchar(32)
	, pDeviceId varchar(32)
	, pOwnerId varchar(32)
	, pDeviceCode varchar(32)
	, pDeviceStatus char(1)
	, pDeviceType char(1)
	, pDeviceType2 char(1)
	, pDeviceValueId varchar(32)
	, pPush char(1)
	, pSms char(1)
	, pResolution varchar(16)
	, pQuality varchar(16)
	, pDeviceValueType char(1)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	device_relationship_id varchar(32)
	, device_id varchar(32)
	, owner_id varchar(32)
	, app_name varchar(64)
	, create_date timestamp without time zone
	, device_name varchar(32)
	, device_code varchar(32)
	, device_status char(1)
	, device_type char(1)
	, device_type2 char(1)
	, device_description text
	, device_create_date timestamp without time zone
	, device_last_update timestamp without time zone
  , device_deployment_date date
  , device_value_id varchar(32)
  , device_value_name varchar(32)
  , push char(1)
  , sms char(1)
  , token varchar(256)
  , resolution varchar(16)
  , hash varchar(60)
  , description text
  , quality varchar(16)
  , device_value_type char(1)
  , device_value_create_date timestamp without time zone
  , device_value_last_update timestamp without time zone
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
    FROM device_relationship dr LEFT JOIN device d ON dr.device_id = d.device_id
    LEFT JOIN device_value dv ON d.device_id = dv.device_id WHERE (
        ((pDeviceRelationshipId IS NULL) OR (dr.device_relationship_id = pDeviceRelationshipId)) AND
        ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId)) AND
        ((pOwnerId IS NULL) OR (dr.owner_id = pOwnerId)) AND
        ((pDeviceCode IS NULL) OR (d.code = pDeviceCode)) AND
        ((pDeviceStatus IS NULL) OR (d.status = pDeviceStatus)) AND
        ((pDeviceType IS NULL) OR (d.type = pDeviceType)) AND
        ((pDeviceType2 IS NULL) OR (d.type2 = pDeviceType2)) AND
        ((pDeviceValueId IS NULL) OR (dv.device_value_id = pDeviceValueId)) AND
        ((pPush IS NULL) OR (dv.push = pPush)) AND
        ((pSms IS NULL) OR (dv.sms = pSms)) AND
        ((pResolution IS NULL) OR (dv.resolution = pResolution)) AND
        ((pQuality IS NULL) OR (dv.quality = pQuality)) AND
        ((pDeviceValueType IS NULL) OR (dv.type = pDeviceValueType))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE device_relationship_init AS
      SELECT
        dr.device_relationship_id
        , dr.device_id
        , dr.owner_id
        , dr.app_name
        , dr.create_date
        , d.name AS device_name
        , d.code AS device_code
        , d.status AS device_status
        , d.type AS device_type
        , d.type2 AS device_type2
        , d.description AS device_description
        , d.create_date AS device_create_date
        , d.last_update AS device_last_update
        , d.deployment_date AS device_deployment_date
        , dv.device_value_id
        , dv.name AS device_value_name
        , dv.push
        , dv.sms
        , dv.token
        , dv.resolution
        , dv.hash
        , dv.description
        , dv.quality
        , dv.type AS device_value_type
        , dv.create_date AS device_value_create_date
        , dv.last_update AS device_value_last_update
    FROM device_relationship dr LEFT JOIN device d ON dr.device_id = d.device_id
    LEFT JOIN device_value dv ON d.device_id = dv.device_id WHERE (
        ((pDeviceRelationshipId IS NULL) OR (dr.device_relationship_id = pDeviceRelationshipId)) AND
        ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId)) AND
        ((pOwnerId IS NULL) OR (dr.owner_id = pOwnerId)) AND
        ((pDeviceCode IS NULL) OR (d.code = pDeviceCode)) AND
        ((pDeviceStatus IS NULL) OR (d.status = pDeviceStatus)) AND
        ((pDeviceType IS NULL) OR (d.type = pDeviceType)) AND
        ((pDeviceType2 IS NULL) OR (d.type2 = pDeviceType2)) AND
        ((pDeviceValueId IS NULL) OR (dv.device_value_id = pDeviceValueId)) AND
        ((pPush IS NULL) OR (dv.push = pPush)) AND
        ((pSms IS NULL) OR (dv.sms = pSms)) AND
        ((pResolution IS NULL) OR (dv.resolution = pResolution)) AND
        ((pQuality IS NULL) OR (dv.quality = pQuality)) AND
        ((pDeviceValueType IS NULL) OR (dv.type = pDeviceValueType))
        )
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM device_relationship_init;

END;
$BODY$
LANGUAGE plpgsql;
