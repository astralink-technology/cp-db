-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = ''get_away_analytics'' LOOP
  EXECUTE ''DROP FUNCTION '' || fname;
END loop;
RAISE INFO ''FUNCTION % DROPPED'', fname;
END$$;
-- Start function
CREATE FUNCTION get_away_analytics(
        pDeviceId varchar(32)
        , pDay date
    )
RETURNS TABLE(
    eyecare_id varchar(32),
    away_start timestamp without time zone,
    away_end timestamp without time zone
  )
AS
$BODY$
DECLARE
    oEyeCareId varchar(32);
    oEventTypeId varchar(64);
    oEventTypeName varchar(64);
    oNodeName varchar(64);
    oZone varchar(64);
    oCreateDate timestamp without time zone;
    oExtraData varchar(64);
BEGIN

    SELECT
      e.eyecare_id
      , e.event_type_id
      , e.event_type_name
      , e.node_name
      , e.zone
      , e.create_date
      , e.extra_data
    INTO STRICT
      oEyeCareId
      , oEventTypeId
      , oEventTypeName
      , oNodeName
      , oZone
      , oCreateDate
      , oExtraData
    FROM eyecare e
    WHERE e.create_date BETWEEN (pDay  || ''T'' || ''00:00'')::timestamp AND ((pDay || ''T'' || ''23:59'')::timestamp)
    AND ((pDeviceId = NULL) OR (e.device_id = pDeviceId))  AND (
          (e.node_name = ''Door sensor'' AND e.event_type_id = ''20001'' AND e.extra_data IN (''Alarm On'', ''Alarm Off'')) OR -- door sensor alarm report on door open "Alarm On"
          (e.event_type_id IN (''20002'', ''20003'', ''20004'') AND e.zone = ''Master Bedroom'') OR -- Bedroom motion sensor alarm on
          (e.event_type_id IN (''20002'', ''20003'', ''20004'') AND e.zone = ''Kitchen'') OR -- Kitchen  motion sensor alarm on
          (e.event_type_id IN (''20002'', ''20003'', ''20005'') AND e.zone = ''Bathroom'') -- Get only the sensor off in the bathroom
--           (e.eyecare_id NOT IN
--             (
--               SELECT ee.eyecare_id
--                                 FROM (
--                                   SELECT ee.*,
--                                          lead(ee.event_type_id) over (ORDER BY ee.eyecare_id) AS next_event_type_id,
--                                          lead(ee.create_date) over (ORDER BY ee.eyecare_id) AS next_create_date
--                                   FROM eyecare ee WHERE
--                                   (ee.create_date BETWEEN (pDay  || ''T'' || ''00:00'')::timestamp AND ((pDay || ''T'' || ''23:59'')::timestamp)) AND
--                                   ((pDeviceId = NULL) OR (ee.device_id = pDeviceId))
--                                  ) ee WHERE
--                                 ee.zone = ''Bathroom'' AND
--                                (ee.event_type_id IN (''20010'') OR (ee.event_type_id = ''20004'' AND next_event_type_id = ''20010''))
--             )
           )
    ORDER BY eyecare_id LIMIT 1;

    CREATE TEMP TABLE away_analytics_temp AS
      SELECT e.eyecare_id, e.create_date AS away_start, e.next_create_date AS away_end
      from (SELECT e.*,
                   lead(e.create_date) over (ORDER BY e.eyecare_id) AS next_create_date,
                   lead(e.event_type_id) over (ORDER BY e.eyecare_id) AS next_event_type_id
            from eyecare e
            WHERE e.create_date BETWEEN (pDay  || ''T'' || ''00:00'')::timestamp AND ((pDay || ''T'' || ''23:59'')::timestamp) AND
            ((pDeviceId = NULL) OR (e.device_id = pDeviceId)) AND (
        (e.node_name = ''Door sensor'' AND e.event_type_id = ''20001'' AND e.extra_data IN (''Alarm On'', ''Alarm Off'')) OR -- door sensor alarm report on door open "Alarm On"
        (e.event_type_id IN (''20002'', ''20003'', ''20004'') AND e.zone = ''Master Bedroom'') OR -- Bedroom motion sensor alarm on
        (e.event_type_id IN (''20002'', ''20003'', ''20004'') AND e.zone = ''Kitchen'') OR -- Kitchen  motion sensor alarm on
        (e.event_type_id IN (''20002'', ''20003'', ''20005'') AND e.zone = ''Bathroom'') -- Get only the sensor off in the bathroom
--         (e.eyecare_id NOT IN
--           (
--             SELECT ee.eyecare_id
--                               FROM (
--                                 SELECT ee.*,
--                                        lead(ee.event_type_id) over (ORDER BY ee.eyecare_id) AS next_event_type_id,
--                                        lead(ee.create_date) over (ORDER BY ee.eyecare_id) AS next_create_date
--                                 FROM eyecare ee WHERE
--                                 (ee.create_date BETWEEN (pDay  || ''T'' || ''00:00'')::timestamp AND ((pDay || ''T'' || ''23:59'')::timestamp)) AND
--                                 ((pDeviceId = NULL) OR (ee.device_id = pDeviceId))
--                                ) ee WHERE
--                               ee.zone = ''Bathroom'' AND
--                              (ee.event_type_id IN (''20010'') OR (ee.event_type_id = ''20004'' AND next_event_type_id = ''20010''))
--           )
--         )
        )
           ) e WHERE
      e.event_type_id = ''20001''
      AND e.zone = ''Living room''
      AND e.extra_data = ''Alarm Off''
      AND (next_event_type_id IS NULL OR next_event_type_id IN (''20001''))
      AND (next_create_date > create_date + 0.5 * INTERVAL ''1 hour'' OR next_create_date IS NULL);

    IF (oEventTypeId IS NOT NULL AND oEventTypeID = ''20001'' AND oExtraData = ''Alarm On'') THEN
      INSERT INTO away_analytics_temp (eyecare_id, away_start, away_end) VALUES (oEyeCareId, null, oCreateDate);
    END IF;

    RETURN QUERY
      SELECT * FROM away_analytics_temp ORDER BY eyecare_id;

END;
$BODY$
LANGUAGE plpgsql;
