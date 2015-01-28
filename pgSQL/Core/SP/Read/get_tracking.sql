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
    , pOwnerId varchar(32)
    , pType varchar(4)
    , pCountryCode varchar(8)
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
    , create_date timestamp without time zone
    , owner_id varchar(32)
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
        , t.create_date
        , t.owner_id
      FROM tracking t WHERE (
        ((pTrackingId IS NULL) OR (t.tracking_id = pTrackingId)) AND
        ((pType IS NULL) OR (t.type = pType)) AND
        ((pCountryCode IS NULL) OR (t.country_code = pCountryCode)) AND
        ((pOwnerId IS NULL) OR (t.owner_id = pOwnerId))
    )
    LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM tracking_init;
END;
$BODY$
LANGUAGE plpgsql;
