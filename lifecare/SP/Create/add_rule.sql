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
      , pArmState varchar(16)
      , pOwnerId varchar(32)
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
        , arm_state
        , owner_id
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
        , pArmState
        , pOwnerId
    );
    RETURN pRuleId;
END;
$BODY$
LANGUAGE plpgsql;