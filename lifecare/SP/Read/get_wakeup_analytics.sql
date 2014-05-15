-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_wakeup_analytics' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_wakeup_analytics(
        pDeviceId varchar(32)
        , pDay date
    )
RETURNS TABLE(
    create_date timestamp without time zone
  )
AS
$BODY$
BEGIN
    RETURN QUERY

    SELECT e.create_date FROM eyecare e WHERE(
       (e.node_name = 'Door sensor' AND e.event_type_id = '20001' AND e.extra_data IN ('Alarm On', 'Alarm Off')) OR -- door sensor alarm report on door open "Alarm On"
       (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Master Bedroom') OR -- Bedroom motion sensor alarm on
       (e.event_type_id IN ('20002', '20003', '20004') AND e.zone = 'Kitchen') OR -- Kitchen  motion sensor alarm on
       (e.event_type_id IN ('20002', '20003', '20005') AND e.zone = 'Bathroom') -- Get only the sensor off in the bathroom
       ) AND
    ((pDay IS NULL) OR (e.create_date BETWEEN (pDay || 'T' || '05:00')::timestamp AND (pDay || 'T' || '23:00:00')::timestamp)) AND
    ((pDeviceId IS NULL) OR (e.device_id = pDeviceId))
    ORDER BY e.create_date ASC
    LIMIT 1 OFFSET 20;

END;
$BODY$
LANGUAGE plpgsql;
