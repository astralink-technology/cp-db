-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_sip' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_sip(
        pSipId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- SIP ID is needed if not return
    IF pSipId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from sip where
        sip_id = pSipId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;