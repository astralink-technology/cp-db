-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_day_bathroom_usage_frequency' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_day_bathroom_usage_frequency(
      pOwnerId varchar(32)
      , pDay date
    )
RETURNS TABLE(
      day_bathroom_usage_frequency integer
  )
AS
$BODY$
BEGIN
    RETURN QUERY
      SELECT
        ia.int_value AS day_bathroom_usage_frequency
      FROM informative_analytics ia WHERE
      ia.type = 'DBF' AND (
        ((pOwnerId IS NULL) OR (ia.owner_id = pOwnerId)) AND
        ((pDay IS NULL) OR (ia.date_value = (pDay || 'T' || '00:00')::timestamp))
      );
END;
$BODY$
LANGUAGE plpgsql;