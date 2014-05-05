-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_analytics(
       pEntityId varchar(32)
        , pZone varchar(64)
        , pDeviceId varchar(32)
        , pEventTypeId varchar(32)
        , pStartDateTime timestamp without time zone
        , pEndDateTime timestamp without time zone
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
    , extra_data varchar(64)
    , entity_id varchar(32)
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
          FROM eyecare e WHERE (
           e.event_type_id NOT IN ('20010', '20004') AND
          ((pEntityId IS NULL) OR (e.entity_id = pEntityId)) AND
          ((pZone IS NULL) OR (e.zone = pZone)) AND
          ((pDeviceId IS NULL) OR (e.device_id = pDeviceId)) AND
          ((pEventTypeId IS NULL) OR (e.event_type_id = pEventTypeId)) AND
          ((pZone IS NULL) OR (e.zone = pZone)) AND
          ((pStartDateTime IS NULL OR pEndDateTime IS NULL) OR (e.create_date BETWEEN pStartDateTime AND pEndDateTime)) -- might have syntax error
        )
      ORDER BY e.create_date ASC;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM eyecare_init;

END;
$BODY$
LANGUAGE plpgsql;
