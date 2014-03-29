-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_product_registration(
        pProductRegistrationId varchar(32)
);
-- Start function
CREATE FUNCTION delete_product_registration(
        pProductRegistrationId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
    IF pProductRegistrationId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from product_registration where 
        product_registration_id = pProductRegistrationId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;