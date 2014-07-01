-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_informative_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_informative_analytics(
        pInformativeAnalyticsId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Authentication ID is needed if not return
    IF pInformativeAnalyticsId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from informative_analytics where
          informative_analytics_id = pInformativeAnalyticsId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;