-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_enterprise_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_enterprise_relationship(
       pEnterpriseRelationshipId varchar(32)
       , pEnterpriseId varchar(32)
       , pOwnerId varchar(32)
       , pStatus char(1)
       , pType varchar(4)
       , pPageSize integer
       , pSkipSize integer
    )
RETURNS TABLE(
  enterprise_relationship_id varchar(32)
  , enterprise_id varchar(32)
  , owner_id varchar(32)
  , status char(1)
  , type varchar(4)
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
    FROM enterprise_relationship;

    -- create a temp table to get the data
    CREATE TEMP TABLE enterprise_relationship_init AS
      SELECT
          er.enterprise_relationship_id
          , er.enterprise_id
          , er.owner_id
          , er.status
          , er.type
          , er.create_date
          , er.last_update
      FROM enterprise_relationship er WHERE (
        ((pEnterpriseRelationshipId IS NULL) OR (er.enterprise_relationship_id = pEnterpriseRelationshipId)) AND
        ((pEnterpriseId IS NULL) OR (er.enterprise_id = pEnterpriseId)) AND
        ((pOwnerId IS NULL) OR (er.owner_id = pOwnerId)) AND
        ((pStatus IS NULL) OR (er.status = pStatus)) AND
        ((pType IS NULL) OR (er.type = pType))
        )
      ORDER BY er.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM enterprise_relationship_init;

END;
$BODY$
LANGUAGE plpgsql;