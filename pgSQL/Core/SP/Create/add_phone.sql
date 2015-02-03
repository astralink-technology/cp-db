-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_phone' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
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
