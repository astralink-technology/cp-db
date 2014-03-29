-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS get_device_details(
	pDeviceId varchar(32)
	, pName varchar(32)
	, pCode varchar(32)
	, pStatus char(1)
	, pType char(1)
	, pType2 char(1)
	, pPush char(1)
	, pToken varchar(128)
	, pSms char(1)
	, pQuality char(16)
	, pResolution varchar(16)
	, pDeviceValueType varchar(32)
	, pOwnerId varchar(32)
	, pPageSize integer
	, pSkipSize integer
);
-- Start function
CREATE FUNCTION get_device_details(
	pDeviceId varchar(32)
	, pName varchar(32)
	, pCode varchar(32)
	, pStatus char(1)
	, pType char(1)
	, pType2 char(1)
	, pPush char(1)
	, pToken varchar(128)
	, pSms char(1)
	, pQuality char(16)
	, pResolution varchar(16)
	, pDeviceValueType varchar(32)
	, pOwnerId varchar(32)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	device_id varchar(32)
	, device_value_id varchar(32)
	, name varchar(32)
	, code varchar(32)
	, status char(1)
	, type char(1)
	, type2 char(1)
	, description text
	, push char(1)
	, token varchar(128)
	, sms char(1)
	, quality varchar(16)
	, resolution varchar(16)
	, device_value_type varchar(32)
	, last_update timestamp without time zone
	, device_last_update timestamp without time zone
	, owner_id varchar(32)
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
    device_value dv ON d.device_id = dv.device_id WHERE
    (
      ((pDeviceId IS NULL) OR (d.device_id = pDeviceId)) AND
      ((pOwnerId IS NULL) OR (d.owner_id = pOwnerId)) AND
      ((pName IS NULL) OR (d.name = pName)) AND
      ((pCode IS NULL) OR (d.code = pCode))AND
      ((pStatus IS NULL) OR (d.status = pStatus))AND
      ((pType IS NULL) OR (d.type = pType))AND
      ((pType2 IS NULL) OR (d.type2 = pType2)) AND
      ((pPush IS NULL) OR (dv.push = pPush)) AND
      ((pToken IS NULL) OR (dv.token = pToken)) AND
      ((pSms IS NULL) OR (dv.sms = pSms)) AND
      ((pQuality IS NULL) OR (dv.quality = pQuality)) AND
      ((pResolution IS NULL) OR (dv.resolution = pResolution)) AND
      ((pDeviceValueType IS NULL) OR (dv.type = pDeviceValueType))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE device_detail_init AS
      SELECT
        d.device_id
        , dv.device_value_id
        , d.name
        , d.code
        , d.status
        , d.type
        , d.type2
        , d.description
        , dv.push
        , dv.token
        , dv.sms
        , dv.quality
        , dv.resolution
        , dv.type as device_value_type
        , d.last_update
        , dv.last_update as device_value_last_update
        , d.owner_id
      FROM device d INNER JOIN
      device_value dv ON d.device_id = dv.device_id WHERE
      (
        ((pDeviceId IS NULL) OR (d.device_id = pDeviceId)) AND
        ((pOwnerId IS NULL) OR (d.owner_id = pOwnerId)) AND
        ((pName IS NULL) OR (d.name = pName)) AND
        ((pCode IS NULL) OR (d.code = pCode))AND
        ((pStatus IS NULL) OR (d.status = pStatus))AND
        ((pType IS NULL) OR (d.type = pType))AND
        ((pType2 IS NULL) OR (d.type2 = pType2)) AND
        ((pPush IS NULL) OR (dv.push = pPush)) AND
        ((pToken IS NULL) OR (dv.token = pToken)) AND
        ((pSms IS NULL) OR (dv.sms = pSms)) AND
        ((pQuality IS NULL) OR (dv.quality = pQuality)) AND
        ((pResolution IS NULL) OR (dv.resolution = pResolution)) AND
        ((pDeviceValueType IS NULL) OR (dv.type = pDeviceValueType))
      )
    ORDER BY d.create_date
    LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM device_detail_init;
END;
$BODY$
LANGUAGE plpgsql;
