-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS get_product_value(
	  pProductValueId varchar(32)
	, pProductValueName varchar(256)
	, pValue decimal
	, pValue2 decimal
	, pValue3 decimal
	, pValueUnit varchar(32)
	, pStatus char(1)
	, pType char(1)
	, pProductId varchar(32)
	, pPageSize integer
	, pSkipSize integer
);
-- Start function
CREATE FUNCTION get_product_value(
	  pProductValueId varchar(32)
	, pProductValueName varchar(256)
	, pValue decimal
	, pValue2 decimal
	, pValue3 decimal
	, pValueUnit varchar(32)
	, pStatus char(1)
	, pType char(1)
	, pProductId varchar(32)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	product_value_id varchar(32)
	, product_value_name varchar(256)
	, value decimal
	, value2 decimal
	, value3 decimal
	, value_unit varchar(32)
	, status char(1)
	, type char(1)
	, create_date timestamp without time zone
	, last_update timestamp without time zone
	, product_id varchar(32)
	, total_rows integer
) AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM product_value pv  WHERE (
      ((pProductValueId IS NULL) OR (pv.product_value_id = pProductValueId)) AND
      ((pProductId IS NULL) OR (pv.product_id = pProductId)) AND
      ((pProductValueName IS NULL) OR (pv.product_value_name = pProductValueName)) AND
      ((pValue IS NULL) OR (pv.value = pValue)) AND
      ((pValue2 IS NULL) OR (pv.value2 = pValue2)) AND
      ((pValue3 IS NULL) OR (pv.value3 = pValue3)) AND
      ((pValueUnit IS NULL) OR (pv.value_unit = pValueUnit)) AND
      ((pStatus IS NULL) OR (pv.status = pStatus)) AND
      ((pType IS NULL) OR (pv.type = pType))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE product_value_init AS
      SELECT
        pv.product_value_id
        , pv.product_value_name
        , pv.value
        , pv.value2
        , pv.value3
        , pv.value_unit
        , pv.status
        , pv.type
        , pv.create_date
        , pv.last_update
        , pv.product_id
      FROM product_value pv  WHERE (
        ((pProductValueId IS NULL) OR (pv.product_value_id = pProductValueId)) AND
        ((pProductId IS NULL) OR (pv.product_id = pProductId)) AND
        ((pProductValueName IS NULL) OR (pv.product_value_name = pProductValueName)) AND
        ((pValue IS NULL) OR (pv.value = pValue)) AND
        ((pValue2 IS NULL) OR (pv.value2 = pValue2)) AND
        ((pValue3 IS NULL) OR (pv.value3 = pValue3)) AND
        ((pValueUnit IS NULL) OR (pv.value_unit = pValueUnit)) AND
        ((pStatus IS NULL) OR (pv.status = pStatus)) AND
        ((pType IS NULL) OR (pv.type = pType))
    )
    ORDER BY pv.create_date
    LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM product_value_init;

END;
$BODY$
LANGUAGE plpgsql;
