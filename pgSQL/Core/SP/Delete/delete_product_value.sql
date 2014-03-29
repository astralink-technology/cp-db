-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_product_value(
        pProducValueId varchar(32)
);
-- Start function
CREATE FUNCTION delete_product_value(
        pProducValueId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
    IF pProducValueId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from product_value where
        product_value_id = pProducValueId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;