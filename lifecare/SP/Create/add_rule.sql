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
      , pRuleName varchar(20)
      , pIdentification varchar(32)
      , pType char(1)
      , pStartTime integer
      , pEndTime integer
      , pActivityType varchar(32)
      , pActivityName varchar(32)
      , pAlertDuration integer
      , pAlertTriggerInterval integer
      , pCreateDate timestamp without time zone
      , pZone varchar(32)
      , pZoneCode varchar(8)
      , pArmState varchar(16)
      , pOwnerId varchar(64)
      , pEntityId varchar(64)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO rule(
        rule_id
        , rule_name
        , identification
        , type
        , start_time
        , end_time
        , activity_type
        , activity_name
        , alert_duration
        , alert_trigger_interval
        , create_date
        , zone
        , zone_code
        , arm_state
        , owner_id
        , entity_id
    ) VALUES(
        pRuleId
        , pRuleName
        , pIdentification
        , pType
        , pStartTime
        , pEndTime
        , pActivityType
        , pActivityName
        , pAlertDuration
        , pAlertTriggerInterval
        , pCreateDate
        , pZone
        , pZoneCode
        , pArmState
        , pOwnerId
        , pEntityId
    );
    RETURN pRuleId;
END;
$BODY$
LANGUAGE plpgsql;