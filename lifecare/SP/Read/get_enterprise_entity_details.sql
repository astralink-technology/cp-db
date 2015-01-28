-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_enterprise_entity_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_enterprise_entity_details(
        pEnterpriseId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
	entity_id varchar(32)
	, first_name varchar(32)
	, last_name varchar(32)
	, nick_name varchar(32)
	, name varchar(64)
	, status char(1)
	, location_name varchar(128)
	, approved boolean
	, type char(1)
	, authorization_level int
	, authentication_string varchar(64)
	, enterprise_id varchar(32)
	, enterprise_name varchar(32)
	, external_unique_identifier varchar(32)
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
    FROM enterprise_relationship er
    LEFT JOIN enterprise et ON et.enterprise_id = er.enterprise_id
    LEFT JOIN entity e ON e.entity_id = er.owner_id
    INNER JOIN authentication a ON a.authentication_id = e.authentication_id;

    -- create a temp table to get the data
    CREATE TEMP TABLE enterprise_entity_relationship_init AS
      SELECT
        e.entity_id
        , e.first_name
        , e.last_name
        , e.nick_name
        , e.name
        , e.status
        , e.location_name
        , e.approved
        , e.type
        , a.authorization_level
        , a.authentication_string
        , et.enterprise_id
        , et.name as enterprise_name
        , er.external_unique_identifier
    FROM enterprise_relationship er
    LEFT JOIN enterprise et ON et.enterprise_id = er.enterprise_id
    LEFT JOIN entity e ON e.entity_id = er.owner_id
    INNER JOIN authentication a ON a.authentication_id = e.authentication_id WHERE
      (
        ((pEnterpriseId IS NULL) OR (er.enterprise_id = pEnterpriseId))
      )
    LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
      SELECT
        *
        , totalRows
      FROM enterprise_entity_relationship_init;

END;
$BODY$
LANGUAGE plpgsql;