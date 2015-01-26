-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_return_home_statistics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_return_home_statistics(
      pOwnerId varchar(32)
      , pDay date
    )
RETURNS TABLE(
      return_home_has_patterns integer
      , return_home_start integer
      , return_home_end integer
  )
AS
$BODY$
BEGIN
    RETURN QUERY
      SELECT
        ia.int_value AS return_home_has_patterns
        , ia.int_value2 AS return_home_start
        , ia.int_value3 AS return_home_end
      FROM informative_analytics ia WHERE
      ia.type = 'RH' AND (
        ((pOwnerId IS NULL) OR (ia.owner_id = pOwnerId)) AND
        ((pDay IS NULL) OR (ia.date_value = (pDay || 'T' || '00:00')::timestamp))
      );
END;
$BODY$
LANGUAGE plpgsql;