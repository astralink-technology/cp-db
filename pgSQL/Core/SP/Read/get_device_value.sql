-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_device_value' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_device_value(
	pDeviceValueId varchar(32)
	, pPush char(1)
	, pSms char(1)
	, pToken varchar(256)
	, pType varchar(32)
	, pResolution varchar(16)
	, pQuality varchar(16)
	, pDeviceId varchar(32)
	, pPageSize integer
	, pSkipSize integer
	, pLocationName varchar(64)
	, pLatitude decimal
	, pLongitude decimal
	, pAppVersion varchar(64)
	, pFirmwareVersion varchar(64)
)
RETURNS TABLE(
	device_value_id varchar(32),
	push char(1),
	sms char(1),
	token varchar(256),
	type varchar(32),
	resolution varchar(16),
	quality varchar(16),
	hash varchar(60),
	salt varchar(16),
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	device_id varchar(32),
	description text,
	location_name varchar(64),
	latitude decimal,
	longitude decimal,
	app_version varchar(16),
	firmware_version varchar(16),
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
    FROM device_value dv WHERE (
      ((pDeviceValueId IS NULL) OR (dv.device_value_id = pDeviceValueId)) AND
      ((pDeviceId IS NULL) OR (dv.device_id = pDeviceId))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE device_value_init AS
      SELECT
        dv.device_value_id
        , dv.push
        , dv.sms
        , dv.token
        , dv.type
        , dv.resolution
        , dv.quality
        , dv.hash
        , dv.salt
        , dv.create_date
        , dv.last_update
        , dv.device_id
        , dv.description
        , dv.location_name
        , dv.latitude
        , dv.longitude
        , dv.app_version
        , dv.firmware_version
      FROM device_value dv WHERE (
        ((pDeviceValueId IS NULL) OR (dv.device_value_id = pDeviceValueId)) AND
        ((pDeviceId IS NULL) OR (dv.device_id = pDeviceId))
      )
      ORDER BY dv.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM device_value_init;
END;
$BODY$
LANGUAGE plpgsql;

