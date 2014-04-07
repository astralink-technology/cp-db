-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_enterprise' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_enterprise(
	pEnterpriseId varchar(32) 
        , pName varchar(32)
        , pCode varchar(64)
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
    FROM enterprise e WHERE (
      ((pEnterpriseId IS NULL) OR (e.enterprise_id = pEnterpriseId)) AND
      ((pName IS NULL) OR (e.name = pName)) AND
      ((pCode IS NULL) OR (e.code = pCode))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE enterprise_init AS
      SELECT
          e.enterprise_id
          , e.name
          , e.code
          , e.description
          , e.create_date
        , e.last_update
      FROM enterprise e WHERE (
        ((pEnterpriseId IS NULL) OR (e.enterprise_id = pEnterpriseId)) AND
        ((pName IS NULL) OR (e.name = pName)) AND
        ((pCode IS NULL) OR (e.code = pCode))
        )
      ORDER BY e.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM enterprise_init;

END;
$BODY$
LANGUAGE plpgsql;