-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_enterprise(
	pEnterpriseId varchar(32) 
        , pName varchar(32)
        , pCode varchar(64)
        , pDescription text
        , pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
);
-- Start function
CREATE FUNCTION add_enterprise(
	pEnterpriseId varchar(32) 
        , pName varchar(32)
        , pCode varchar(64)
        , pDescription text
        , pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO enterprise (
	enterpriseId 
        , name
        , code
        , description
        , createDate
	, lastUpdate
    ) VALUES(
	pEnterpriseId
        , pName
        , pCode
        , pDescription
        , pCreateDate
	, pLastUpdate
    );
    RETURN pEnterpriseId;
END;
$BODY$
LANGUAGE plpgsql;