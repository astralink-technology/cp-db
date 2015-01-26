-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_median_sleeping_time' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_median_sleeping_time(
      pOwnerId varchar(32)
      , pDay date
    )
RETURNS TABLE(
      median_sleeping_time timestamp without time zone
  )
AS
$BODY$
BEGIN
    RETURN QUERY

      SELECT
        ia.date_value2 AS median_sleeping_time
      FROM informative_analytics ia WHERE
      ia.type = 'MS' AND (
        ((pOwnerId IS NULL) OR (ia.owner_id = pOwnerId)) AND
        ((pDay IS NULL) OR (ia.date_value = (pDay || 'T' || '00:00')::timestamp))
      );
END;
$BODY$
LANGUAGE plpgsql;