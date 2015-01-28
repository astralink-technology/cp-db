-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_tracking' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_tracking(
        pTrackingId varchar(32)
)
RETURNS BOOLEAN AS
$BODY$
BEGIN
-- Phone ID is needed if not return
    IF pTrackingId  IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from tracking WHERE (
		      tracking_id = pTrackingId
	      );
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

