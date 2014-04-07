-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_product' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_product(
	pProductId varchar(32)
	, pName varchar(32)
	, pStatus char(1)
	, pType char(1)
	, pCode varchar(60)
	, pOwnerId varchar(32)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	product_id varchar(32), 
	name varchar(32), 
	description text,
	code varchar (60),
  type char (1),
  status char(1),
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	owner_id varchar(32),
	total_rows integer
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
    FROM product p  WHERE (
        ((pProductId IS NULL) OR (p.product_id = pProductId)) AND
        ((pOwnerId IS NULL) OR (p.owner_id = pOwnerId)) AND
        ((pName IS NULL) OR (p.name = pName)) AND
        ((pType IS NULL) OR (p.type = pType)) AND
        ((pCode IS NULL) OR (p.code = pCode)) AND
        ((pStatus IS NULL) OR (p.status = pStatus))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE product_init AS
      SELECT
        p.product_id
        , p.name
        , p.description
        , p.code
        , p.type
        , p.status
        , p.create_date
        , p.last_update
        , p.owner_id
      FROM product p  WHERE (
        ((pProductId IS NULL) OR (p.product_id = pProductId)) AND
        ((pOwnerId IS NULL) OR (p.owner_id = pOwnerId)) AND
        ((pName IS NULL) OR (p.name = pName)) AND
        ((pType IS NULL) OR (p.type = pType)) AND
        ((pCode IS NULL) OR (p.code = pCode)) AND
        ((pStatus IS NULL) OR (p.status = pStatus))
    )
    ORDER BY p.create_date
    LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM product_init;
END;
$BODY$
LANGUAGE plpgsql;
