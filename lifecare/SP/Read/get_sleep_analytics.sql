-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_sleep_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_sleep_analytics(
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

    SELECT e.create_date
    FROM (
      SELECT e.create_date, lead(e.create_date) over (ORDER BY e.create_date) AS next_create_date
      FROM eyecare e
      WHERE e.create_date BETWEEN (pDay  || 'T' || '23:00')::timestamp AND ((pDay || 'T' || '05:00')::timestamp + INTERVAL '1 day') AND
     ((pDeviceId IS NULL) OR (e.device_id = pDeviceId)) AND
      e.event_type_id NOT IN  ('20010', '20004')
      ORDER BY e.create_date ASC
    ) e
    WHERE e.next_create_date > e.create_date + 2 * INTERVAL '1 hour'
    LIMIT 1;

END;
$BODY$
LANGUAGE plpgsql;
