-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_tracking' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_tracking(
    pTrackingId varchar(32)
    , pCountryCode varchar(8)
    , pType varchar(4)
    , pOperatingSystem varchar(256)
    , pOperatingSystemVersion varchar(256)
    , pUserAgent varchar(256)
    , pUserAgentVersion varchar(256)
    , pDevice varchar(256)
    , pOwnerId varchar(32)
    , pPageSize integer
    , pSkipSize integer
)
RETURNS TABLE(
	tracking_id varchar(32)
	, name text
	, ip_address text
	, country varchar(256)
	, country_code varchar(8)
	, type varchar(4)
	, operating_system varchar(256)
	, operating_system_version varchar(256)
	, user_agent varchar(256)
	, user_agent_version varchar(256)
	, device varchar(256)
	, extra_data text
	, create_date timestamp without time zone
	, owner_id varchar(32)
	, totalRows integer
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
    FROM tracking;

    -- create a temp table to get the data
    CREATE TEMP TABLE tracking_init AS
      SELECT
        t.tracking_id
        , t.name
        , t.ip_address
        , t.country
        , t.country_code
        , t.type
        , t.operating_system
        , t.operating_system_version
        , t.user_agent
        , t.user_agent_version
        , t.device
        , t.extra_data
        , t.create_date
        , t.owner_id
      FROM tracking t WHERE (
        ((pTrackingId IS NULL) OR (t.tracking_id = pTrackingId)) AND
        ((pCountryCode IS NULL) OR (t.country_code = pCountryCode)) AND
        ((pType IS NULL) OR (t.type = pType)) AND
        ((pOperatingSystem IS NULL) OR (t.operating_system = pOperatingSystem)) AND
        ((pOperatingSystemVersion IS NULL) OR (t.operating_system_version= pOperatingSystemVersion)) AND
        ((pUserAgent IS NULL) OR (t.user_agent = pUserAgent)) AND
        ((pUserAgentVersion IS NULL) OR (t.user_agent_version = pUserAgentVersion)) AND
        ((pDevice IS NULL) OR (t.device = pDevice)) AND
        ((pOwnerId IS NULL) OR (t.owner_id = pOwnerId))
    )
    ORDER BY t.create_date DESC
    LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM tracking_init;
END;
$BODY$
LANGUAGE plpgsql;
