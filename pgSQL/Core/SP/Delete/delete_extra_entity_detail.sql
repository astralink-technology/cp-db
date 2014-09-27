-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_extra_entity_detail' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_extra_entity_detail(
        pExtraEntityDetailId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Extra Entity Detail ID is needed if not return
    IF pExtraEntityDetailId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from extra_entity_detail where
        extra_entity_detail_id = pExtraEntityDetailId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;