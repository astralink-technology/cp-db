  -- Drop function
  DO $$
  DECLARE fname text;
  BEGIN
  FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_nights_away_analytics' LOOP
    EXECUTE 'DROP FUNCTION ' || fname;
  END loop;
  RAISE INFO 'FUNCTION % DROPPED', fname;
  END$$;
  -- Start function
  CREATE FUNCTION get_nights_away_analytics(
          pDeviceId varchar(32)
          , pDateStart date
          , pDateEnd date
          , pEntityId varchar(32)
      )
  RETURNS integer
  AS
  $BODY$
  DECLARE
    nights_away_count integer default 0;
  BEGIN

    SELECT
      COUNT(*)
    INTO
      nights_away_count
    FROM analytics_value WHERE
    type = 'A' AND
    date_value2 IS NOT NULL AND
    date_value3 IS NULL AND (
      ((pDeviceId IS NULL) OR (owner_id = pDeviceId)) AND
      ((pEntityId IS NULL) OR (entity_id = pEntityId)) AND
      ((pDateStart IS NULL OR pDateEnd IS NULL) OR (date_value BETWEEN (pDateStart  || 'T' || '00:00')::timestamp AND (pDateEnd  || 'T' || '00:00')::timestamp))
    );

    RETURN nights_away_count;

  END;
  $BODY$
  LANGUAGE plpgsql;
