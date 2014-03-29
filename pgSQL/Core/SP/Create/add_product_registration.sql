-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_product_registration(
	pProductRegistrationId varchar(32),
	pStatus char(1),
	pType char(1),
	pCreateDate timestamp without time zone,
	pLastUpdate timestamp without time zone,
	pProductId varchar(32),
	pEntityId varchar(32)
);
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
