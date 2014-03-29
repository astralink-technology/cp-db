-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS update_authentication(
        pAuthenticationId varchar(32)
        , pAuthenticationString varchar(32)
        , pAuthenticationStringLower varchar(32)
        , pHash varchar(60)
        , pSalt varchar(16)
        , pLastLogin timestamp without time zone
        , pLastLogout timestamp without time zone
        , pLastChangePassword timestamp without time zone
        , pRequestAuthenticationStart timestamp without time zone
        , pRequestAuthenticationEnd timestamp without time zone
        , pAuthorizationLevel integer
        , pLastUpdate timestamp without time zone
);
-- Start function
CREATE FUNCTION update_authentication(
        pAuthenticationId varchar(32)
        , pAuthenticationString varchar(32)
        , pAuthenticationStringLower varchar(32)
        , pHash varchar(60)
        , pSalt varchar(16)
        , pLastLogin timestamp without time zone
        , pLastLogout timestamp without time zone
        , pLastChangePassword timestamp without time zone
        , pRequestAuthenticationStart timestamp without time zone
        , pRequestAuthenticationEnd timestamp without time zone
        , pAuthorizationLevel integer
        , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oAuthenticationString varchar(32);
    oAuthenticationStringLower varchar(32);
    oHash varchar(60);
    oSalt varchar(16);
    oLastLogin timestamp without time zone;
    oLastLogout timestamp without time zone;
    oLastChangePassword timestamp without time zone;
    oRequestAuthenticationStart timestamp without time zone;
    oRequestAuthenticationEnd timestamp without time zone;
    oAuthorizationLevel integer;
    oLastUpdate timestamp without time zone;

    nAuthenticationString varchar(32);
    nAuthenticationStringLower varchar(32);
    nHash varchar(60);
    nSalt varchar(16);
    nLastLogin timestamp without time zone;
    nLastLogout timestamp without time zone;
    nLastChangePassword timestamp without time zone;
    nRequestAuthenticationStart timestamp without time zone;
    nRequestAuthenticationEnd timestamp without time zone;
    nAuthorizationLevel integer;
    nLastUpdate timestamp without time zone;
BEGIN
    -- Authentication ID is needed if not return
    IF pAuthenticationId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            a.authentication_string 
            , a.authentication_string_lower 
            , a.hash 
            , a.salt 
            , a.last_login 
            , a.last_logout
            , a.last_change_password 
            , a.request_authentication_start 
            , a.request_authentication_end 
            , a.authorization_level 
            , a.last_update 
        INTO STRICT
            oAuthenticationString
            , oAuthenticationStringLower 
            , oHash
            , oSalt
            , oLastLogin
            , oLastLogout
            , oLastChangePassword
            , oRequestAuthenticationStart
            , oRequestAuthenticationEnd
            , oAuthorizationLevel
            , oLastUpdate
        FROM authentication a WHERE 
            a.authentication_id = pAuthenticationId;


        -- Start the updating process
        IF pAuthenticationString IS NULL THEN 
            nAuthenticationString := oAuthenticationString;
        ELSEIF pAuthenticationString = '' THEN   
            -- defaulted null
            nAuthenticationString := NULL;
        ELSE
            nAuthenticationString := pAuthenticationString;
        END IF;

        IF pAuthenticationStringLower IS NULL THEN 
            nAuthenticationStringLower := oAuthenticationStringLower;
        ELSEIF pAuthenticationStringLower = '' THEN   
            -- defaulted null
            nAuthenticationStringLower := NULL;
        ELSE
            nAuthenticationStringLower := pAuthenticationStringLower;
        END IF;

        IF pHash IS NULL THEN 
            nHash := oHash;
        ELSEIF pHash = '' THEN   
            -- defaulted null
            nHash := NULL;
        ELSE
            nHash := pHash;
        END IF;

        IF pSalt IS NULL THEN 
            nSalt := oSalt;
        ELSEIF pSalt  = '' THEN   
            -- defaulted null
        ELSE
            nSalt := pSalt;
        END IF;

        IF pLastLogin IS NULL THEN 
            nLastLogin := oLastLogin;
        ELSE
            nLastLogin := pLastLogin;
        END IF;

        IF pLastLogout IS NULL THEN 
            nLastLogout := oLastLogout;
        ELSE
            nLastLogout := pLastLogout;
        END IF;

        IF pLastChangePassword IS NULL THEN 
            nLastChangePassword := oLastChangePassword;
        ELSE
            nLastChangePassword := pLastChangePassword;
        END IF;

        IF pRequestAuthenticationStart IS NULL THEN 
            nRequestAuthenticationStart := oRequestAuthenticationStart;
        ELSE
            nRequestAuthenticationStart := pRequestAuthenticationStart;
        END IF;

        IF pRequestAuthenticationEnd IS NULL THEN 
            nRequestAuthenticationEnd := oRequestAuthenticationEnd;
        ELSE
            nRequestAuthenticationEnd := pRequestAuthenticationEnd;
        END IF;

        IF pAuthorizationLevel IS NULL THEN 
            nAuthorizationLevel := oAuthorizationLevel;
        ELSE
            nAuthorizationLevel := pAuthorizationLevel;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            authentication
        SET 
            authentication_string = nAuthenticationString
            , authentication_string_lower  = nAuthenticationStringLower
            , hash  = nHash
            , salt = nSalt
            , last_login = nLastLogin
            , last_logout = nLastLogout
            , last_change_password = nLastChangePassword
            , request_authentication_start = nRequestAuthenticationStart
            , request_authentication_end = nRequestAuthenticationEnd
            , authorization_level = nAuthorizationLevel
            , last_update  = nLastUpdate
        WHERE 
            authentication_id = pAuthenticationId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;