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
      SELECT create_date, lead(create_date) over (ORDER BY create_date) as next_create_date
      FROM eyecare e
      WHERE create_date BETWEEN (pDay - INTERVAL '1 day' || 'T' || '23:00') AND (pDay || 'T' || '05:00') AND
      event_type_id NOT IN  ('20010', '20004')
      ORDER BY create_date ASC
    ) e
    WHERE next_create_date > create_date + 2 * INTERvAL '1 hour'
    LIMIT 1;

END;
$BODY$
LANGUAGE plpgsql;
