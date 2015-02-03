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
	device_id varchar(32)
	, name varchar(32)
	, code varchar(32)
	, status char(1)
	, type varchar(4)
	, type2 varchar(4)
	, description text
	, create_date timestamp without time zone
	, last_update timestamp without time zone
	, owner_id varchar(32)
	, deployment_date date
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