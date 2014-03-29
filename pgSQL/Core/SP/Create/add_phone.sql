-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_phone(
    pPhoneId varchar(32) 
    , pPhoneDigits varchar(32) 
    , pDigits varchar(32)
    , pCountryCode varchar(4)
    , pCode varchar(8)
    , pCreateDate timestamp without time zone
    , pLastUpdate timestamp without time zone
    , pEntityId varchar(32)
    , pDeviceId varchar(32)
);
-- Start function
CREATE FUNCTION add_phone(
    pPhoneId varchar(32) 
    , pPhoneDigits varchar(32) 
    , pDigits varchar(32)
    , pCountryCode varchar(4)
    , pCode varchar(8)
    , pCreateDate timestamp without time zone
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO phone (
	phone_id 
	, phone_digits 
	, digits
	, country_code
	, code
	, create_date 
	, last_update 
	, owner_id
    ) VALUES(
        pPhoneId 
        , pPhoneDigits 
        , pDigits
        , pCountryCode
        , pCode
        , pCreateDate
        , pLastUpdate
        , pOwnerId
    );
    RETURN pPhoneId;
END;
$BODY$
LANGUAGE plpgsql;
