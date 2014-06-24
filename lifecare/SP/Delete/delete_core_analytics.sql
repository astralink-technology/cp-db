-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_core_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_core_analytics(
        pCoreAnalyticsId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Core Analytics ID is needed if not return
    IF pCoreAnalyticsId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from core_analytics where
        core_analytics_id = pCoreAnalyticsId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;