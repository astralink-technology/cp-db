-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_feature' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_feature(
        pFeatureId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Feature ID is needed if not return
    IF pFeatureId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from feature where
        feature_id = pFeatureId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;