-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS get_phone(
	pPhoneId varchar(32) 
	, pPhoneDigits varchar(32) 
	, pDigits varchar(32)
	, pCountryCode varchar(4)
	, pCode varchar(8)
	, pOwnerId varchar(32)
	, pPageSize integer
	, pSkipSize integer
);
-- Start function
CREATE FUNCTION get_phone(
	pPhoneId varchar(32) 
	, pPhoneDigits varchar(32) 
	, pDigits varchar(32)
	, pCountryCode varchar(4)
	, pCode varchar(8)
	, pOwnerId varchar(32)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	phone_id varchar(32) 
	, phone_digits varchar(32) 
	, digits varchar(32)
	, country_code varchar(4)
	, code varchar(8)
	, create_date timestamp without time zone
	, last_update timestamp without time zone
	, owner_id varchar(32)
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
      FROM phone p WHERE (
        ((pPhoneId IS NULL) OR (p.phone_id = pPhoneId)) AND
        ((pPhoneDigits IS NULL) OR (p.phone_digits = pPhoneDigits)) AND
        ((pDigits IS NULL) OR (p.digits = pDigits)) AND
        ((pCountryCode IS NULL) OR (p.country_code = pCountryCode)) AND
        ((pCode IS NULL) OR (p.code = pCode)) AND
        ((pOwnerId IS NULL) OR (p.owner_id = pOwnerId))
        );

    -- create a temp table to get the data
    CREATE TEMP TABLE phone_init AS
      SELECT
        p.phone_id
        , p.phone_digits
        , p.digits
        , p.country_code
        , p.code
        , p.create_date
        , p.last_update
        , p.owner_id
      FROM phone p WHERE (
        ((pPhoneId IS NULL) OR (p.phone_id = pPhoneId)) AND
        ((pPhoneDigits IS NULL) OR (p.phone_digits = pPhoneDigits)) AND
        ((pDigits IS NULL) OR (p.digits = pDigits)) AND
        ((pCountryCode IS NULL) OR (p.country_code = pCountryCode)) AND
        ((pCode IS NULL) OR (p.code = pCode)) AND
        ((pOwnerId IS NULL) OR (p.owner_id = pOwnerId))
        )
      ORDER BY p.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM phone_init;
END;
$BODY$
LANGUAGE plpgsql;
