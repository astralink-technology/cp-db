-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_wakeup_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_wakeup_analytics(
        pDeviceId varchar(32)
        , pDay date
    )
RETURNS TABLE(
    create_date timestamp without time zone
  )
AS
$BODY$
BEGIN
    RETURN QUERY

    SELECT e.create_date FROM eyecare e WHERE
    ((pDay IS NULL) OR (e.create_date BETWEEN (pDay || 'T' || '05:00')::timestamp AND (pDay || 'T' || '23:00:00')::timestamp)) AND
    ((pDeviceId IS NULL) OR (e.device_id = pDeviceId)) AND
    e.event_type_id NOT IN  ('20010', '20004')
    ORDER BY e.create_date ASC
    LIMIT 1;

END;
$BODY$
LANGUAGE plpgsql;
