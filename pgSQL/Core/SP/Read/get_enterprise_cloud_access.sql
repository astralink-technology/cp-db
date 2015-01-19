-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_enterprise_cloud_access' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_enterprise_cloud_access(
       pEnterpriseId varchar(32)
       , pPageSize integer
       , pSkipSize integer
    )
RETURNS TABLE(
  enterprise_id varchar(32)
  , name varchar(32)
  , code varchar(64)
  , description text
  , create_date timestamp without time zone
  , last_update timestamp without time zone
  , cloud_access_id varchar(32)
  , token text
  , secret varchar(32)
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
    FROM enterprise e INNER JOIN cloud_access ca ON ca.owner_id = e.enterprise_id;

    -- create a temp table to get the data
    CREATE TEMP TABLE enterprise_cloud_access_init AS
      SELECT
          e.enterprise_id
          , e.name
          , e.code
          , e.description
          , e.create_date
          , e.last_update
          , ca.cloud_access_id
          , ca.token
          , ca.secret
      FROM enterprise e INNER JOIN cloud_access ca ON ca.owner_id = e.enterprise_id WHERE (
        ((pEnterpriseId IS NULL) OR (e.enterprise_id = pEnterpriseId))
        )
      ORDER BY e.name ASC
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM enterprise_cloud_access_init;

END;
$BODY$
LANGUAGE plpgsql;