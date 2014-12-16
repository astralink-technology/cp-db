-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_cloud_access' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_cloud_access(
        pCloudAccessId varchar(32)
        , pOwnerId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
    cloud_access_id varchar(32)
    , secret varchar(32)
    , extra_data text
    , extra_date_time timestamp without time zone
    , create_date timestamp without time zone
    , last_update timestamp without time zone
    , owner_id varchar(32)
    , token text
    , total_rows integer
  )
AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM cloud_access;

    -- create a temp table to get the data
    CREATE TEMP TABLE cloud_access_init AS
      SELECT
        ca.cloud_access_id
        , ca.secret
        , ca.extra_data
        , ca.extra_date_time
        , ca.create_date
        , ca.last_update
        , ca.owner_id
        , ca.token
          FROM cloud_access ca WHERE (
           ((pCloudAccessId IS NULL) OR (ca.cloud_access_id = pCloudAccessId)) AND
           ((pOwnerId IS NULL) OR (ca.owner_id = pOwnerId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM cloud_access_init;
END;
$BODY$
LANGUAGE plpgsql;