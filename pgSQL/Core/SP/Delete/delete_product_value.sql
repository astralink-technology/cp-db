-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_product_value' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
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