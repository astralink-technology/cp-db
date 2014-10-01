-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_address' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_address(
	pAddressId varchar(32)
	, pType char(1)
	, pStatus char(1)
	, pOwnerId varchar(32)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
    address_id varchar(32)
    , apartment varchar(64)
    , road_name text
    , road_name2 text
    , suite varchar(32)
    , zip varchar(16)
    , country varchar(128)
    , province varchar(128)
    , state varchar(128)
    , city varchar(128)
    , type char (1)
    , status char(1)
    , longitude decimal
    , latitude decimal
    , create_date timestamp without time zone
    , last_update timestamp without time zone
    , owner_id varchar(32)
    , totalRows integer
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
    FROM address a WHERE (
      ((pOwnerId IS NULL) OR (a.owner_id = pOwnerId)) AND
      ((pType IS NULL) OR (a.type = pType)) AND
      ((pStatus IS NULL) OR (a.status = pStatus))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE address_init AS
      SELECT
        a.address_id
      , a.apartment
      , a.road_name
      , a.road_name2
      , a.suite
      , a.zip
      , a.country
      , a.province
      , a.state
      , a.city
      , a.type
      , a.status
      , a.longitude
      , a.latitude
      , a.create_date
      , a.last_update
      , a.owner_id
      FROM address a WHERE (
        ((pOwnerId IS NULL) OR (a.owner_id = pOwnerId)) AND
        ((pType IS NULL) OR (a.type = pType)) AND
        ((pStatus IS NULL) OR (a.status = pStatus))
      )
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
    *
    , totalRows
    FROM
      address_init a;

END;
$BODY$
LANGUAGE plpgsql;
