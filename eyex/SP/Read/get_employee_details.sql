-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_employee_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_employee_details(
        pEntityId varchar(32)
        , pEmployeeId varchar(32)
        , pEntityStatus char(1)
        , hasExtension bool
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
    entity_id varchar(32)
    , first_name varchar(32)
    , last_name varchar(32)
    , name varchar(64)
    , nick_name varchar(32)
    , entity_status char(1)
    , entity_approved boolean
    , entity_disabled boolean
    , date_established timestamp without time zone
    , related_entity_status char(1)
    , related_entity_type char(1)
    , authentication_id varchar(32)
    , authentication_string_lower varchar(64)
    , last_login timestamp without time zone
    , authorization_level integer
    , request_authentication_start timestamp without time zone
    , request_authentication_end timestamp without time zone
    , access_id varchar(32)
    , pin varchar(8)
    , card_id text
    , extension_id varchar(32)
    , access_create_date timestamp without time zone
    , address_id varchar(32)
    , apartment varchar(64)
    , road_name text
    , road_name2 text
    , suite varchar(32)
    , zip varchar(6)
    , country varchar(128)
    , province varchar(128)
    , state varchar(128)
    , city varchar(128)
    , address_type char(1)
    , address_status char(1)
    , longitude decimal
    , latitude decimal
    , totalRwos integer
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
    FROM entity_relationship eri WHERE eri.entity_id = pEntityId;

    -- create a temp table to get the data
    CREATE TEMP TABLE employee_detail_init AS
      SELECT
          e.entity_id
          , e.first_name
          , e.last_name
          , e.name
          , e.nick_name
          , e.status AS entity_status
          , e.approved AS entity_approved
          , e.disabled AS entity_disabled
          , e.date_established
          , er.status AS related_entity_status
          , er.type AS related_entity_type
          , au.authentication_id
          , au.authentication_string_lower
          , au.last_login
          , au.authorization_level
          , au.request_authentication_start
          , au.request_authentication_end
          , a.access_id
          , a.pin
          , a.card_id
          , a.extension_id
          , a.create_date AS access_create_date
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
          , ad.type AS address_type
          , ad.status AS address_status
          , ad.longitude
          , ad.latitude
        FROM entity_relationship er INNER JOIN entity e ON er.related_id = e.entity_id
        INNER JOIN authentication au ON e.authentication_id = au.authentication_id
        LEFT JOIN access a ON e.entity_id = a.owner_id
        LEFT JOIN address ad ON ad.owner_id = e.entity_id WHERE
        (
          ((pEntityId IS NULL) OR (er.entity_id = pEntityId)) AND
          ((pEntityStatus IS NULL) OR (e.status = pEntityStatus)) AND
           ((hasExtension IS NULL) OR ((hasExtension = false) AND (a.extension_id IS NULL))) AND
          ((pEmployeeId IS NULL) OR (pEmployeeId = er.related_id))
        )
        LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
      SELECT
        *
        , totalRows
      FROM employee_detail_init;
END;
$BODY$
LANGUAGE plpgsql;