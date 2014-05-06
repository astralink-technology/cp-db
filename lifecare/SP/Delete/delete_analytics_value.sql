-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_analytics_value' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_analytics_value(
        pAnalyticsValueId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Authentication ID is needed if not return
    IF pAnalyticsValueId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from analytics_value where
        analytics_value_id = pAnalyticsValueId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;