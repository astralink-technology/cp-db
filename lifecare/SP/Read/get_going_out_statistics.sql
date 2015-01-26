-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_going_out_statistics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_going_out_statistics(
      pOwnerId varchar(32)
      , pDay date
    )
RETURNS TABLE(
      going_out_has_patterns integer
      , going_out_start integer
      , going_out_end integer
  )
AS
$BODY$
BEGIN
    RETURN QUERY
      SELECT
        ia.int_value AS going_out_has_patterns
        , ia.int_value2 AS going_out_start
        , ia.int_value3 AS going_out_end
      FROM informative_analytics ia WHERE
      ia.type = 'GO' AND (
        ((pOwnerId IS NULL) OR (ia.owner_id = pOwnerId)) AND
        ((pDay IS NULL) OR (ia.date_value = (pDay || 'T' || '00:00')::timestamp))
      );
END;
$BODY$
LANGUAGE plpgsql;