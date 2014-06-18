-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_entity_relationship_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_entity_relationship_details(
        pEntityRelationshipId varchar(32)
        , pEntityId varchar(32)
        , pRelatedId varchar(32)
        , pStatus char(1)
        , pType char(1)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
    entity_relationship_id varchar(32)
    , status char(1)
    , type char(1)
    , create_date timestamp without time zone
    , entity_id varchar(32)
    , related_id varchar(32)
    , entity_name varchar(64)
    , entity_first_name varchar(32)
    , entity_last_name varchar(32)
    , entity_type char(1)
    , entity_status char(1)
    , entity_create_date timestamp without time zone
    , entity_authentication_id varchar(32)
    , entity_authorization_level integer
    , entity_authentication_string varchar(32)
    , entity_last_login timestamp without time zone
    , entity_last_logout timestamp without time zone
    , related_entity_name varchar(64)
    , related_entity_first_name varchar(32)
    , related_entity_last_name varchar(32)
    , related_entity_type char(1)
    , related_entity_status char(1)
    , related_entity_create_date timestamp without time zone
    , related_entity_authentication_id varchar(32)
    , related_entity_authorization_level integer
    , related_entity_authentication_string varchar(32)
    , related_entity_last_login timestamp without time zone
    , related_entity_last_logout timestamp without time zone
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
    FROM entity_relationship er INNER JOIN
          entity e ON e.entity_id = er.entity_id INNER JOIN
          authentication ea ON ea.authentication_id = e.authentication_id INNER JOIN
          entity ee ON er.related_id = ee.entity_id INNER JOIN
          authentication eea ON eea.authentication_id = ee.authentication_id WHERE (
            ((pEntityId IS NULL) OR (er.entity_id = pEntityId)) AND
            ((pRelatedId IS NULL) OR (er.related_id = pRelatedId)) AND
            ((pStatus IS NULL) OR (er.status = pStatus)) AND
            ((pType IS NULL) OR (er.type = pType)) AND
            ((pEntityRelationshipId IS NULL) OR (er.entity_relationship_id = pEntityRelationshipId))
        );

    -- create a temp table to get the data
    CREATE TEMP TABLE entity_relationship_init AS
       SELECT
        er.entity_relationship_id
        , er.status
        , er.type
        , er.create_date
        , e.entity_id as entity_id
        , ee.entity_id as related_id
        , e.name as entity_name
        , e.first_name as entity_first_name
        , e.last_name as entity_last_name
        , e.type as enity_type
        , e.status as entity_status
        , e.create_date as entity_create_date
        , ea.authentication_id as entity_authentication_id
        , ea.authorization_level as entity_authorization_level
        , ea.authentication_string as entity_authentication_string
        , ea.last_login as entity_last_login
        , ea.last_logout as entity_last_logout
        , ee.name as related_entity_name
        , ee.first_name as related_entity_first_name
        , ee.last_name as related_entity_last_name
        , ee.type as related_entity_type
        , ee.status as related_entity_status
        , ee.create_date as related_entity_create_date
        , eea.authentication_id as related_authentication_id
        , eea.authorization_level as related_entity_authorization_level
        , eea.authentication_string as related_entity_authentication_string
        , eea.last_login as related_entity_last_login
        , eea.last_logout as related_entity_last_logout
          FROM entity_relationship er INNER JOIN
          entity e ON e.entity_id = er.entity_id INNER JOIN
          authentication ea ON ea.authentication_id = e.authentication_id INNER JOIN
          entity ee ON er.related_id = ee.entity_id INNER JOIN
          authentication eea ON eea.authentication_id = ee.authentication_id WHERE (
            ((pEntityId IS NULL) OR (er.entity_id = pEntityId)) AND
            ((pRelatedId IS NULL) OR (er.related_id = pRelatedId)) AND
            ((pStatus IS NULL) OR (er.status = pStatus)) AND
            ((pType IS NULL) OR (er.type = pType)) AND
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
