-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_weighing_scale_readings' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_weighing_scale_readings(
       pEntityId varchar(32)
        , pDeviceId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
    eyecare_id varchar(32)
    , event_type_name varchar(64)
    , event_type_id varchar(64)
    , node_id varchar(64)
    , node_name varchar(64)
    , zone varchar(64)
    , create_date timestamp without time zone
    , device_id varchar(32)
    , home_id varchar(32)
    , extra_data text
    , entity_id varchar(32)
    , entity_name varchar(64)
    , total_rows integer
  )
AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM eyecare;

    -- create a temp table to get the data
    CREATE TEMP TABLE eyecare_init AS
      SELECT
        e.eyecare_id
        , e.event_type_name
        , e.event_type_id
        , e.node_id
        , e.node_name
        , e.zone
        , e.create_date
        , e.device_id
        , e.home_id
        , e.extra_data
        , e.entity_id
        , ey.name as entity_name
      FROM eyecare e LEFT JOIN entity ey ON e.entity_id = ey.entity_id WHERE (
          (e.event_type_id = '20014') AND -- Get Weighing Scale Reading
          ((pEntityId IS NULL) OR (e.entity_id = pEntityId)) AND
          ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
        )
      ORDER BY e.create_date DESC
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM eyecare_init;

END;
$BODY$
LANGUAGE plpgsql;
