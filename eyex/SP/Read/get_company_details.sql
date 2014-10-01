-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_company_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_company_details(
        pCompanyId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
  entity_id varchar(32)
  , name varchar(64)
  , status char(1)
  , approved boolean
  , disabled boolean
  , date_established timestamp without time zone
  , authentication_id varchar(32)
  , authentication_string_lower varchar(64)
  , last_login timestamp without time zone
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
  , type char(1)
  , file_name text
  , img_url text
  , img_url2 text
  , phone_id varchar(32)
  , digits varchar(32)
  , phone_digits varchar(32)
  , country_code varchar(4)
  , code varchar(8)
  , web_protocol varchar(128)
  , web_address varchar(128)
  , work_start timestamp without time zone
  , work_end timestamp without time zone
  , work_days varchar(128)
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
    FROM entity e INNER JOIN extra_entity_detail ee ON ee.owner_id = e.entity_id INNER JOIN
      authentication au ON au.authentication_id = e.authentication_id LEFT JOIN
      phone p ON p.owner_id= e.primary_phone_id LEFT JOIN
      address ad ON ad.address_id = ee.related_detail_id LEFT JOIN
      media m ON m.owner_id = ee.related_detail_id2;

    -- create a temp table to get the data
    CREATE TEMP TABLE company_detail_init AS
      SELECT
          e.entity_id
          , e.name
          , e.status
          , e.approved
          , e.disabled
          , e.date_established
          , au.authentication_id
          , au.authentication_string_lower
          , au.last_login
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
          , m.type
          , m.file_name
          , m.img_url
          , m.img_url2
          , p.phone_id
          , p.digits
          , p.phone_digits
          , p.country_code
          , p.code
          , ee.detail2 web_protocol
          , ee.detail3 web_address
          , ee.date_time_detail AS work_start
          , ee.date_time_detail2 AS work_end
          , ee.detail AS work_days
        FROM entity e INNER JOIN extra_entity_detail ee ON ee.owner_id = e.entity_id
        INNER JOIN authentication au ON au.authentication_id = e.authentication_id LEFT JOIN
        phone p ON p.phone_id = e.primary_phone_id LEFT JOIN
        address ad ON ad.address_id = ee.related_detail_id LEFT JOIN
        media m ON m.owner_id = ee.related_detail_id2 WHERE
        (
          ((pCompanyId IS NULL) OR (e.entity_id = pCompanyId))
        )
        LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
      SELECT
        *
        , totalRows
      FROM company_detail_init;
END;
$BODY$
LANGUAGE plpgsql;