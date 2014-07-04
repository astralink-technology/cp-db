-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_community_detail' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_community_detail(
        pEntityId varchar(32)
        , pAuthenticationId varchar(32)
        , pAuthorizationLevels integer
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
	, date_established timestamp without time zone
	, authentication_id varchar(32)
	, primary_email_id varchar(32)
	, primary_phone_id varchar(32)
	, authorization_level int
	, last_login timestamp without time zone
	, last_logout timestamp without time zone
	, authentication_string varchar(64)
	, phone_id varchar(32)
	, digits varchar(32)
	, phone_digits varchar(32)
	, country_code varchar(4)
	, code varchar(8)
	, address_id varchar(32)
	, apartment varchar(64)
	, road_name text
	, road_name2 text
	, suite varchar(32)
	, zip varchar(16)
	, country varchar(128)
	, province varchar(128)
	, state varchar(128)
	, city varchar(128)
	, address_type char(1)
	, address_status char(1)
	, longitude decimal
	, latitude decimal
	, device_id varchar(32)
	, device_name varchar(32)
	, device_type char(1)
	, deployment_date date
	, total_rows integer
) AS
$BODY$
DECLARE
    totalRows integer;
    erRow record;
    cRow record;

    vEntityId varchar(32);
    vRelatedId varchar(32);
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM entity e INNER JOIN
      authentication a ON a.authentication_id = e.authentication_id LEFT JOIN
      address ad ON ad.owner_id = e.entity_id LEFT JOIN
      phone p ON p.owner_id = e.entity_id;

    -- create a temp table to get the data
    CREATE TEMP TABLE entity_init AS
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
        , e.date_established
        , e.authentication_id
        , e.primary_email_id
        , e.primary_phone_id
        , a.authorization_level
        , a.last_login
        , a.last_logout
        , a.authentication_string
        , p.phone_id
        , p.digits
        , p.phone_digits
        , p.country_code
        , p.code
        , ad.address_id
        , ad.apartment
        , ad.road_name
        , ad.road_name2
        , ad.suite
        , ad.zip
        , ad.country
        , ad.province
        , ad.state
        , ad.city
        , ad.type as address_type
        , ad.status as address_status
        , ad.longitude
        , ad.latitude
      FROM entity e INNER JOIN
      authentication a ON a.authentication_id = e.authentication_id LEFT JOIN
      address ad ON ad.owner_id = e.entity_id LEFT JOIN
      phone p ON p.owner_id = e.entity_id WHERE
      (
        ((pEntityId IS NULL) OR (e.entity_id = pEntityId)) AND
        ((pAuthorizationLevels IS NULL) OR (a.authorization_level = pAuthorizationLevels)) AND
        ((pAuthenticationId IS NULL) OR (e.authentication_id = pAuthenticationId))
      )
      LIMIT pPageSize OFFSET pSkipSize;

    CREATE TEMP TABLE device_init AS
      SELECT
        d.device_id
        , dr.owner_id
        , d.name
        , d.type
        , d.deployment_date
      FROM device d INNER JOIN device_relationship dr ON d.device_id = dr.device_id
      WHERE d.type = 'L';

    CREATE TEMP TABLE entity_device_init AS
      SELECT
        ei.*
        , di.device_id
        , di.name as device_name
        , di.type as device_type
        , di.deployment_date
      FROM entity_init ei LEFT JOIN
      device_init di ON di.owner_id = ei.entity_Id;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM entity_device_init;

END;
$BODY$
LANGUAGE plpgsql;