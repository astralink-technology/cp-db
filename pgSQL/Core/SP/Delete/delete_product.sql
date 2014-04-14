-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_product' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
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