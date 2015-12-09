-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_rule' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_rule(
      pRuleId varchar(32)
      , pRuleName varchar(20)
      , pOwnerId varchar(64)
      , pIdentification varchar(32)
      , pType char(1)
      , pStartTime integer
      , pEndTime integer
      , pActivityType varchar(32)
      , pActivityName varchar(32)
      , pAlertDuration integer
      , pAlertTriggerInterval integer
      , pZone varchar(32)
      , pZoneCode varchar(8)
      , pArmState varchar(16)
      , pEntityId varchar(64)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oIdentification varchar(32);
    oRuleName varchar(20);
    oType char(1);
    oStartTime integer;
    oEndTime integer;
    oActivityType varchar(32);
    oActivityName varchar(32);
    oAlertDuration integer;
    oAlertTriggerInterval integer;
    oZone varchar(32);
    oArmState varchar(16);
    oEntityId varchar(64);

    nIdentification varchar(32);
    nRuleName varchar(20);
    nType char(1);
    nStartTime integer;
    nEndTime integer;
    nActivityType varchar(32);
    nActivityName varchar(32);
    nAlertDuration integer;
    nAlertTriggerInterval integer;
    nZone varchar(32);
    nArmState varchar(16);
    nEntityId varchar(64);

BEGIN
    -- Rule ID is needed if not return
    IF pRuleId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            r.identification
            , r.rule_name
            , r.type
            , r.start_time
            , r.end_time
            , r.activity_type
            , r.activity_name
            , r.alert_duration
            , r.alert_trigger_interval
            , r.zone
            , r.arm_state
            , r.entity_id
        INTO STRICT
            oIdentification
            , oRuleName
            , oType
            , oStartTime
            , oEndTime
            , oActivityType
            , oActivityName
            , oAlertDuration
            , oAlertTriggerInterval
            , oZone
            , oArmState
            , oEntityId
        FROM rule r WHERE
            r.rule_id = pRuleId;

        -- Start the updating process
        IF pIdentification IS NULL THEN 
            nIdentification := oIdentification;
        ELSEIF pIdentification = '' THEN   
            -- defaulted null
            nIdentification := NULL;
        ELSE
            nIdentification := pIdentification;
        END IF;

        IF pRuleName IS NULL THEN 
            nRuleName := oRuleName;
        ELSEIF pRuleName = '' THEN   
            -- defaulted null
            nRuleName := NULL;
        ELSE
            nRuleName := pRuleName;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pType = '' THEN   
            -- defaulted null
            nType := NULL;
        ELSE
            nType := pType;
        END IF;
        
        IF pActivityType IS NULL THEN 
            nActivityType := oActivityType;
        ELSEIF pActivityType = '' THEN   
            -- defaulted null
            nActivityType := NULL;
        ELSE
            nActivityType := pActivityType;
        END IF;
        
        IF pActivityName IS NULL THEN 
            nActivityName := oActivityName;
        ELSEIF pActivityName = '' THEN   
            -- defaulted null
            nActivityName := NULL;
        ELSE
            nActivityName := pActivityName;
        END IF;
        
        IF pZone IS NULL THEN
            nZone := oZone;
        ELSEIF pZone = '' THEN
            -- defaulted null
            nZone := NULL;
        ELSE
            nZone := pZone;
        END IF;
        
        IF pArmState IS NULL THEN
            nArmState := oArmState;
        ELSEIF pArmState = '' THEN
            -- defaulted null
            nArmState := NULL;
        ELSE
            nArmState := pArmState;
        END IF;
        
        IF pAlertTriggerInterval IS NULL THEN 
            nAlertTriggerInterval := oAlertTriggerInterval;
        ELSE
            nAlertTriggerInterval := pAlertTriggerInterval;
        END IF;

        IF pStartTime IS NULL THEN 
            nStartTime := oStartTime;
        ELSE
            nStartTime := pStartTime;
        END IF;

        IF pEndTime IS NULL THEN 
            nEndTime := oEndTime;
        ELSE
            nEndTime := pEndTime;
        END IF;

        IF pAlertDuration IS NULL THEN 
            nAlertDuration := oAlertDuration;
        ELSE
            nAlertDuration := pAlertDuration;
        END IF;

        IF pEntityId IS NULL THEN
            nEntityId := oEntityId;
        ELSEIF pEntityId = '' THEN
            -- defaulted null
            nEntityId := NULL;
        ELSE
            nEntityId := pEntityId;
        END IF;

        -- start the update
        UPDATE 
            rule
        SET
            identification = nIdentification
            , rule_name = nRuleName
            , type = nType
            , start_time = nStartTime
            , end_time = nEndTime
            , activity_type = nActivityType
            , activity_name = nActivityName
            , alert_duration = nAlertDuration
            , alert_trigger_interval = nAlertTriggerInterval
            , arm_state = nArmState
            , entity_id = nEntityId
            , zone = nZone
        WHERE
            rule_id = pRuleId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;