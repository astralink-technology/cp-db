-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_product_value' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_product_value(
	  pProductValueId varchar(32)
	, pProductValueName varchar(256)
	, pValue decimal
	, pValue2 decimal
	, pValue3 decimal
	, pValueUnit varchar(32)
	, pStatus char(1)
	, pType char(1)
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
	, pProductId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO product_value(
      product_value_id
      , product_value_name
      , value
      , value2
      , value3
      , value_unit
      , status
      , type
      , create_date
      , last_update
      , product_id
    ) VALUES(
        pProductValueId
      , pProductValueName
      , pValue
      , pValue2
      , pValue3
      , pValueUnit
      , pStatus
      , pType
      , pCreateDate
      , pLastUpdate
      , pProductId
    );
    RETURN pProductValueId;
END;
$BODY$
LANGUAGE plpgsql;