-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_admin_entity_device_relationship_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_admin_entity_device_relationship_details(
        pEntityId varchar(32)
        , pAuthenticationId varchar(32)
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
	, approved boolean
	, type char(1)
	, create_date timestamp without time zone
	, last_update timestamp without time zone
	, authentication_id varchar(32)
	, primary_email_id varchar(32)
	, primary_phone_id varchar(32)
	, authorization_level int
	, last_login timestamp without time zone
	, last_logout timestamp without time zone
	, authentication_string varchar(64)
	, device_id varchar(32)
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
    FROM entity e INNER JOIN
    authentication a ON a.authentication_id = e.authentication_id WHERE (
    ((pEntityId IS NULL) OR (e.entity_id = pEntityId)) AND
    ((pAuthenticationId IS NULL) OR (e.authentication_id = pAuthenticationId))
	  );

    -- create a temp table to get the data
    CREATE TEMP TABLE admin_entity_device_relationship_init AS
      SELECT
        e.entity_id
        , e.first_name
        , e.last_name
        , e.nick_name
        , e.name
        , e.status
        , e.approved
        , e.type
        , a.create_date -- user create date
        , e.last_update
        , e.authentication_id
        , e.primary_email_id
        , e.primary_phone_id
        , a.authorization_level
        , a.last_login
        , a.last_logout
        , a.authentication_string
        , dr.device_id
      FROM entity e INNER JOIN
      authentication a ON a.authentication_id = e.authentication_id LEFT JOIN
      device_relationship dr ON dr.owner_id = e.entity_id WHERE (
      ((pEntityId IS NULL) OR (e.entity_id = pEntityId)) AND
      ((pAuthenticationId IS NULL) OR (e.authentication_id = pAuthenticationId))
      )
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM admin_entity_device_relationship_init;

END;
$BODY$
LANGUAGE plpgsql;