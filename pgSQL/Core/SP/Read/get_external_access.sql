-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_external_access' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_external_access(
       pExternalAccessId varchar(32)
       , pUniqueIdentifier varchar(32)
       , pOwnerId varchar(32)
       , pEnterpriseId varchar(32)
       , pPageSize integer
       , pSkipSize integer
    )
RETURNS TABLE(
    external_access_id varchar(32)
    , unique_identifier varchar(32)
    , owner_id varchar(32)
    , enterprise_id varchar(32)
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
    FROM external_access;

    -- create a temp table to get the data
    CREATE TEMP TABLE external_access_init AS
      SELECT
          ea.external_access_id
          , ea.unique_identifier
          , ea.owner_id
          , ea.enterprise_id
      FROM external_access ea WHERE (
        ((pExternalAccessId IS NULL) OR (ea.external_access_id = pExternalAccessId)) AND
        ((pUniqueIdentifier IS NULL) OR (ea.unique_identifier = pUniqueIdentifier)) AND
        ((pEnterpriseId IS NULL) OR (ea.enterprise_id = pEnterpriseId)) AND
        ((pOwnerId IS NULL) OR (ea.owner_id = pOwnerId))
        )
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM external_access_init;

END;
$BODY$
LANGUAGE plpgsql;