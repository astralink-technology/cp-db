-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_sleep_efficiency' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_sleep_efficiency(
      pOwnerId varchar(32)
      , pDay date
    )
RETURNS TABLE(
      sleep_efficiency integer
      , sleep_efficiency_null_reason varchar(32)
  )
AS
$BODY$
BEGIN
    RETURN QUERY
      SELECT
        ia.int_value AS sleep_efficiency
        , ia.value AS sleep_efficiency_null_reason
      FROM informative_analytics ia WHERE
      ia.type = 'SE' AND (
        ((pOwnerId IS NULL) OR (ia.owner_id = pOwnerId)) AND
        ((pDay IS NULL) OR (ia.date_value = (pDay || 'T' || '00:00')::timestamp))
      );
END;
$BODY$
LANGUAGE plpgsql;