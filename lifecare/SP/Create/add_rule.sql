-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_rule' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_rule(
      pRuleId varchar(32)
      , pIdentification varchar(32)
      , pType char(1)
      , pStartTime time without time zone
      , pEndTime time without time zone
      , pActivityType varchar(32)
      , pActivityName varchar(32)
      , pAlertTriggerTime time without time zone
      , pAlertTriggerInterval interval
      , pCreateDate timestamp without time zone
      , pZone varchar(32)
      , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO analytics_value (
        rule_id
        , identification
        , type
        , start_time
        , end_time
        , activity_type
        , activity_name
        , alert_trigger_time
        , alert_trigger_interval
        , create_date
        , zone
        , owner_id
    ) VALUES(
        pRuleId
        , pIdentification
        , pType
        , pStartTime
        , pEndTime
        , pActivityType
        , pActivityName
        , pAlertTriggerTime
        , pAlertTriggerInterval
        , pCreateDate
        , pZone
        , pOwnerId
    );
    RETURN pAnalyticsValueId;
END;
$BODY$
LANGUAGE plpgsql;