-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_email(
    pEmailId varchar(32)
    , pEmailAddress varchar(64)
    , pCreateDate timestamp without time zone
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
);
-- Start function
CREATE FUNCTION add_email(
    pEmailId varchar(32)
    , pEmailAddress varchar(64)
    , pCreateDate timestamp without time zone
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO email (
	email_id 
	, email_address 
	, create_date
	, last_update
	, owner_id
    ) VALUES(
        pEmailId
        , pEmailAddress
        , pCreateDate
        , pLastUpdate
        , pOwnerId
    );
    RETURN pEmailId;
END;
$BODY$
LANGUAGE plpgsql;