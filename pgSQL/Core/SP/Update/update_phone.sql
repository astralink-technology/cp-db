-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS update_phone(
    pPhoneId varchar(32) 
    , pPhoneDigits varchar(32) 
    , pDigits varchar(32)
    , pCountryCode varchar(4)
    , pCode varchar(8)
    , pLastUpdate timestamp without time zone
    , pEntityId varchar(32)
    , pDeviceId varchar(32)
);
-- Start function
CREATE FUNCTION update_phone(
    pPhoneId varchar(32) 
    , pPhoneDigits varchar(32) 
    , pDigits varchar(32)
    , pCountryCode varchar(4)
    , pCode varchar(8)
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    nPhoneDigits varchar(32); 
    nDigits varchar(32);
    nCountryCode varchar(4);
    nCode varchar(8);
    nLastUpdate timestamp without time zone;
    nOwnerId varchar(32);

    oPhoneDigits varchar(32); 
    oDigits varchar(32);
    oCountryCode varchar(4);
    oCode varchar(8);
    oLastUpdate timestamp without time zone;
    oOwnerId varchar(32);
BEGIN
    -- Phone ID is needed if not return
    IF pPhoneId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            p.phone_digits
            , p.digits
            , p.country_code
            , p.code
            , p.last_update
            , p.owner_id
        INTO STRICT
            oPhoneDigits
            , oDigits
            , oCountryCode
            , oCode
            , oLastUpdate
            , oOwnerId
        FROM phone p WHERE 
            p.phone_id = pPhoneId;

        -- Start the updating process
        IF pPhoneDigits IS NULL THEN 
            nPhoneDigits := oPhoneDigits;
        ELSEIF pPhoneDigits = '' THEN
            nPhoneDigits := NULL;
        ELSE
            nPhoneDigits := pPhoneDigits;
        END IF;
        
        IF pDigits IS NULL THEN
            nDigits := oDigits;
        ELSEIF pDigits = '' THEN
            nDigits := NULL;
        ELSE
            nDigits := pDigits;
        END IF;

        IF pCountryCode IS NULL THEN 
            nCountryCode := oCountryCode;
        ELSEIF pCountryCode = '' THEN  
            nCountryCode := NULL;
        ELSE
            nCountryCode := pCountryCode;
        END IF;

        IF pCode IS NULL THEN 
            nCode := oCode;
        ELSEIF pCode = '' THEN  
            nCode := NULL;
        ELSE
            nCode := pCode;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        IF pOwnerId IS NULL THEN 
            nOwnerId := oOwnerId;
        ELSEIF pOwnerId = '' THEN  
            nOwnerId := NULL;
        ELSE
            nOwnerId := pOwnerId;
        END IF;

        -- start the update
        UPDATE 
            phone
        SET 
            phone_digits = nPhoneDigits
            , digits = nDigits
            , country_code = nCountryCode
            , code = nCode
            , last_update = nLastUpdate
            , owner_id = nOwnerId
        WHERE 
            phone_id = pPhoneId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
