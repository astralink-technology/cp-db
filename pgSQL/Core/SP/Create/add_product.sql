-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_product(
	pProductId varchar(32)
	, pName varchar(32) 
	, pDescription text
	, pStatus char(1)
	, pType char(1)
	, pCode varchar(60)
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
);
-- Start function
CREATE FUNCTION add_product(
	pProductId varchar(32)
	, pName varchar(32) 
	, pDescription text
	, pStatus char(1)
	, pType char(1)
	, pCode varchar(60)
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
	, pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO product(
        product_id
        , name
        , description
        , status
        , type
        , code
        , create_date
        , last_update
        , owner_id
    ) VALUES(
        pProductId
        , pName
        , pDescription
        , pStatus
        , pType
        , pCode
        , pCreateDate
	      , pLastUpdate
	      , pOwnerId
    );
    RETURN pProductId;
END;
$BODY$
LANGUAGE plpgsql;