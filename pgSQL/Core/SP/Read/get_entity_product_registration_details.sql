-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_entity_product_registration_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_entity_product_registration_details(
	pProductRegistrationId varchar(32),
	pStatus char(1),
	pType char(1),
	pProductId varchar(32),
	pOwnerId varchar(32),
	pPageSize integer,
	pSkipSize integer
)
RETURNS TABLE(
	product_registration_id varchar(32),
	status char(1),
	type char(1),
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	product_id varchar(32),
	owner_id varchar(32),
	entity_name varchar(64),
	product_name varchar(32),
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
    FROM product_registration pr INNER JOIN
    entity e ON pr.owner_id = e.entity_id INNER JOIN
    product p ON pr.product_id = p.product_id WHERE (
        ((pProductRegistrationId IS NULL) OR (pr.product_registration_id = pProductRegistrationId)) AND
        ((pStatus IS NULL) OR (pr.status = pStatus))AND
        ((pType IS NULL) OR (pr.Type = pType))AND
        ((pProductId IS NULL) OR (pr.product_id = pProductId))AND
        ((pOwnerId IS NULL) OR (pr.owner_id = pOwnerId))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE entity_product_registration_init AS
      SELECT
        pr.product_registration_id,
        pr.status,
        pr.type,
        pr.create_date,
        pr.last_update,
        pr.product_id,
        pr.owner_id,
        e.name as entity_name,
        p.name as product_name
      FROM product_registration pr INNER JOIN
      entity e ON pr.owner_id = e.entity_id INNER JOIN
      product p ON pr.product_id = p.product_id WHERE (
          ((pProductRegistrationId IS NULL) OR (pr.product_registration_id = pProductRegistrationId)) AND
          ((pStatus IS NULL) OR (pr.status = pStatus))AND
          ((pType IS NULL) OR (pr.Type = pType))AND
          ((pProductId IS NULL) OR (pr.product_id = pProductId))AND
          ((pOwnerId IS NULL) OR (pr.owner_id = pOwnerId))
      )
      ORDER BY pr.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM entity_product_registration_init;
END;
$BODY$
LANGUAGE plpgsql;
