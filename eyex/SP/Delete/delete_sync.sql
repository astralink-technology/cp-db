-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_sync' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_sync(
        pSyncId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- SIP ID is needed if not return
    IF pSyncId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from sync where
        sync_id = pSyncId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;