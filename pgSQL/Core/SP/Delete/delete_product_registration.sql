-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_product(
        pProductId varchar(32)
);
-- Start function
CREATE FUNCTION delete_product(
        pProductId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
    IF pProductId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from product where 
        product_id = pProductId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;