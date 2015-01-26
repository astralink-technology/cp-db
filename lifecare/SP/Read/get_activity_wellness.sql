-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_activity_wellness' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_activity_wellness(
      pOwnerId varchar(32)
      , pDay date
    )
RETURNS TABLE(
      avg_day_activity integer
      , avg_night_activity integer
  )
AS
$BODY$
BEGIN
    RETURN QUERY
      SELECT
        ia.int_value AS avg_day_activity
        , ia.int_value2 AS avg_night_activity
      FROM informative_analytics ia WHERE
      ia.type = 'AVGACT' AND (
        ((pOwnerId IS NULL) OR (ia.owner_id = pOwnerId)) AND
        ((pDay IS NULL) OR (ia.date_value = (pDay || 'T' || '00:00')::timestamp))
      );
END;
$BODY$
LANGUAGE plpgsql;