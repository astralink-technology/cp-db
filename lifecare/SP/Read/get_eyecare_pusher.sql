-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_eyecare_pusher' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_eyecare_pusher(
       pEntityId varchar(32)
        , pZone varchar(64)
        , pDeviceId varchar(32)
        , pEventTypeId varchar(32)
        , pStartDateTime timestamp without time zone
        , pEndDateTime timestamp without time zone
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
    eyecare_id varchar(32)
    , event_type_name varchar(64)
    , event_type_id varchar(64)
    , node_id varchar(64)
    , node_name varchar(64  )
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
          FROM eyecare e inner join entity ey on e.entity_id = ey.entity_id WHERE (
          (
                 (e.event_type_id = '20001' AND ((e.zone IN ('Living Room', 'Living room')) OR e.node_name IN ('Door sensor', 'door sensor') OR e.zone_code = 'LR') AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
                 (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone IN ('Living Room', 'Living room')) OR e.zone_code = 'LR')) OR -- Door Opening and Closing
                 (e.event_type_id IN ('20004') AND e.node_id = '4' AND ((e.zone IN ('Living Room', 'Living room')) OR e.zone_code = 'LR')) OR -- Living room motion detected
                 (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone = 'Master Bedroom') OR e.zone_code = 'MR')) OR -- Bedroom motion sensor alarm on
                 (e.event_type_id IN ('20002', '20003', '20004') AND ((e.zone = 'Kitchen') OR e.zone_code = 'KI')) OR -- Kitchen  motion sensor alarm on
                 (e.event_type_id IN ('20002', '20003', '20005') AND ((e.zone = 'Bathroom') OR e.zone_code = 'BT1')) OR -- Get only the sensor off in the bathroom
                 (e.event_type_id IN ('20013')) -- Get BP HR Reading
           ) AND
          ((pEntityId IS NULL) OR (e.entity_id = pEntityId)) AND
          ((pZone IS NULL) OR (e.zone = pZone)) AND
          ((pDeviceId IS NULL) OR (e.device_id = pDeviceId)) AND
          ((pEventTypeId IS NULL) OR (e.event_type_id = pEventTypeId)) AND
          ((pZone IS NULL) OR (e.zone = pZone)) AND
          ((pStartDateTime IS NULL OR pEndDateTime IS NULL) OR (e.create_date BETWEEN pStartDateTime AND pEndDateTime)) -- might have syntax error
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
