-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS get_device_value(
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
);
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

