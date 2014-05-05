-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_product' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
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