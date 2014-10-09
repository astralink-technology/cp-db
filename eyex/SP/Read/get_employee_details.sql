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
      , entity_type char(1)
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
      , media_id varchar(32)
      , profile_img_title varchar(32)
      , img_type char(1)
      , file_name text
      , img_url text
      , img_url2 text
      , extension integer
      , company_img_url text
      , company_img_url2 text
      , company_name varchar(64)
      , company_phone_id varchar(32)
      , company_digits varchar(32)
      , company_phone_digits varchar(32)
      , company_country_code varchar(4)
      , company_code varchar(8)
      , totalRows integer
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
      FROM entity_relationship er INNER JOIN entity e ON er.related_id = e.entity_id
        INNER JOIN authentication au ON e.authentication_id = au.authentication_id
        LEFT JOIN access a ON e.entity_id = a.owner_id
        LEFT JOIN extension ext ON ext.extension_id = a.extension_id
        LEFT JOIN media m ON e.entity_id = m.owner_id
        LEFT JOIN address ad ON ad.owner_id = e.entity_id
        LEFT JOIN entity ee ON er.entity_id = ee.entity_id
        LEFT JOIN media em ON em.owner_id = ee.entity_id
        LEFT JOIN phone ep ON ep.owner_id = ee.entity_id;

  -- create a temp table to get the data
      CREATE TEMP TABLE employee_detail_init AS
        SELECT
            e.entity_id
            , e.first_name
            , e.last_name
            , e.name
            , e.nick_name
            , e.status AS entity_status
            , e.type AS entity_type
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
            , m.media_id
            , m.title AS profile_img_title
            , m.type AS img_type
            , m.file_name
            , m.img_url
            , m.img_url2
            , ext.extension
            , em.img_url AS company_img_url
            , em.img_url2 AS company_img_url2
            , ee.name AS company_name
            , ep.phone_id AS company_phone_id
            , ep.digits AS company_digits
            , ep.phone_digits AS company_phone_digits
            , ep.country_code AS company_country_code
            , ep.code AS company_code
          FROM entity_relationship er INNER JOIN entity e ON er.related_id = e.entity_id
          INNER JOIN authentication au ON e.authentication_id = au.authentication_id
          LEFT JOIN access a ON e.entity_id = a.owner_id
          LEFT JOIN extension ext ON ext.extension_id = a.extension_id
          LEFT JOIN media m ON e.entity_id = m.owner_id
          LEFT JOIN address ad ON ad.owner_id = e.entity_id
          LEFT JOIN entity ee ON er.entity_id = ee.entity_id
          LEFT JOIN media em ON em.owner_id = ee.entity_id
          LEFT JOIN phone ep ON ep.owner_id = ee.entity_id
          WHERE
          (
            ((pEntityId IS NULL) OR (er.entity_id = pEntityId)) AND
            ((pEntityStatus IS NULL) OR (e.status = pEntityStatus)) AND
             ((hasExtension IS NULL) OR ((hasExtension = false) AND (a.extension_id IS NULL OR a.extension_id = ''))) AND
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