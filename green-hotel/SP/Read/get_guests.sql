-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_guests' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_guests(
        pGuestId varchar(32)
        , pHotelId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
	entity_id varchar(32)
	, first_name varchar(128)
	, last_name varchar(128)
	, nick_name varchar(256)
	, name varchar(256)
	, status char(1)
	, approved boolean
	, disabled boolean
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
	, hotel_id varchar(32)
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
    FROM entity e
    INNER JOIN entity_relationship er ON er.related_id = e.entity_id
    LEFT JOIN authentication a ON a.authentication_id = e.authentication_id LEFT JOIN
    address ad ON ad.owner_id = e.entity_id LEFT JOIN
    phone p ON p.phone_id = e.primary_phone_id;

    -- create a temp table to get the data
    CREATE TEMP TABLE guest_init AS
      SELECT
        e.entity_id
        , e.first_name
        , e.last_name
        , e.nick_name
        , e.name
        , e.status
        , e.approved
        , e.disabled
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
        , er.related_id as hotel_id
      FROM entity e
      INNER JOIN entity_relationship er ON er.related_id = e.entity_id
      LEFT JOIN authentication a ON a.authentication_id = e.authentication_id LEFT JOIN
      address ad ON ad.owner_id = e.entity_id LEFT JOIN
      phone p ON p.phone_id = e.primary_phone_id WHERE (
        ((pHotelId IS NULL) OR (er.entity_id = pHotelId)) AND
        ((pGuestId IS NULL) OR (er.related_id = pGuestId))
      )
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM guest_init;
END;
$BODY$
LANGUAGE plpgsql;