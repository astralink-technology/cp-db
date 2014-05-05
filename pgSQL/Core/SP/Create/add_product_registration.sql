-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_product_registration' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_product_registration(
	pProductRegistrationId varchar(32),
	pStatus char(1),
	pType char(1),
	pCreateDate timestamp without time zone,
	pLastUpdate timestamp without time zone,
	pProductId varchar(32),
	pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO product_registration(
		product_registration_id,
		status,
		type,
		create_date,
		last_update,
		product_id,
		owner_id
    ) VALUES(
		pProductRegistrationId,
		pStatus,
		pType,
		pCreateDate,
		pLastUpdate,
		pProductId,
		pOwnerId
    );
    RETURN pProductRegistrationId;
END;
$BODY$
LANGUAGE plpgsql;
