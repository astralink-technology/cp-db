-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_enterprise' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_enterprise(
        pEnterpriseId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Enterprise ID is needed if not return
    IF pEnterpriseId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from enterprise where 
        enterprise_id = pEnterpriseId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;