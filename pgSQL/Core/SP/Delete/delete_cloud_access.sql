-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_cloud_access' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_cloud_access(
        pCloudAccessId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Authentication ID is needed if not return
    IF pCloudAccessId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from cloud_access where
        cloud_access_id = pCloudAccessId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;