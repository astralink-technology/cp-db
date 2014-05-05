-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_entity_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_entity_relationship(
        pEntityRelationshipId varchar(32)
        , pEntityId varchar(32)
        , pRelatedId varchar(32)
        , pStatus char(1)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
    entity_relationship_id varchar(32)
    , entity_id varchar(32)
    , related_id varchar(32)
    , status char(1)
    , create_date timestamp without time zone
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
    FROM entity;

    -- create a temp table to get the data
    CREATE TEMP TABLE entity_relationship_init AS
      SELECT
        er.entity_relationship_id
        , er.entity_id
        , er.related_id
        , er.status
        , er.create_date
          FROM entity_relationship er WHERE (
          ((pEntityId IS NULL) OR (er.entity_id = pEntityId)) AND
          ((pRelatedId IS NULL) OR (er.related_id = pRelatedId)) AND
          ((pStatus IS NULL) OR (er.status = pStatus)) AND
          ((pEntityRelationshipId IS NULL) OR (er.entity_relationship_id = pEntityRelationshipId))
        )
      ORDER BY er.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM entity_relationship_init;

END;
$BODY$
LANGUAGE plpgsql;
