-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_authentication(
        pAuthenticationId varchar(32)
        , pAuthenticationString varchar(32)
        , pAuthenticationStringLower varchar(32)
        , pHash varchar(60)
        , pSalt varchar(16)
        , pLastLogin  timestamp without time zone
        , pLastLogout  timestamp without time zone
        , pLastChangePassword  timestamp without time zone
        , pRequestAuthenticationStart  timestamp without time zone
        , pRequestAuthenticationEnd  timestamp without time zone
        , pAuthorizationLevel integer
        , pCreateDate  timestamp without time zone
        , pLastUpdate  timestamp without time zone
);
-- Start function
CREATE FUNCTION add_authentication(
        pAuthenticationId varchar(32)
        , pAuthenticationString varchar(32)
        , pAuthenticationStringLower varchar(32)
        , pHash varchar(60)
        , pSalt varchar(16)
        , pLastLogin  timestamp without time zone
        , pLastLogout  timestamp without time zone
        , pLastChangePassword  timestamp without time zone
        , pRequestAuthenticationStart  timestamp without time zone
        , pRequestAuthenticationEnd  timestamp without time zone
        , pAuthorizationLevel integer
        , pCreateDate  timestamp without time zone
        , pLastUpdate  timestamp without time zone
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO authentication (
	authentication_id 
	, authentication_string  
	, authentication_string_lower 
	, hash 
	, salt 
	, last_login 
	, last_logout
	, last_change_password 
	, request_authentication_start 
	, request_authentication_end 
	, authorization_level 
	, create_date
        , last_update                            
    ) VALUES(
        pAuthenticationId 
        , pAuthenticationString 
        , pAuthenticationStringLower 
        , pHash
        , pSalt
        , pLastLogin
        , pLastLogout
        , pLastChangePassword
        , pRequestAuthenticationStart
        , pRequestAuthenticationEnd
        , pAuthorizationLevel
        , pCreateDate
        , pLastUpdate
    );
    RETURN pAuthenticationId;
END;
$BODY$
LANGUAGE plpgsql;