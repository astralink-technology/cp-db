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
      , pRuleName varchar(64)
      , pOwnerId varchar(32)
      , pIdentification varchar(32)
      , pType char(1)
      , pStartTime integer
      , pEndTime integer
      , pActivityType varchar(32)
      , pActivityName varchar(32)
      , pAlertDuration integer
      , pAlertTriggerInterval integer
      , pZone varchar(32)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oIdentification varchar(32);
    oRuleName varchar(64);
    oType char(1);
    oStartTime integer;
    oEndTime integer;
    oActivityType varchar(32);
    oActivityName varchar(32);
    oAlertDuration integer;
    oAlertTriggerInterval integer;

    nIdentification varchar(32);
    nRuleName varchar(64);
    nType char(1);
    nStartTime integer;
    nEndTime integer;
    nActivityType varchar(32);
    nActivityName varchar(32);
    nAlertDuration integer;
    nAlertTriggerInterval integer;

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
        
        IF pAlertTriggerInterval IS NULL THEN 
            nAlertTriggerInterval := oAlertTriggerInterval;
        ELSEIF pAlertTriggerInterval = '' THEN   
            -- defaulted null
            nAlertTriggerInterval := NULL;
        ELSE
            nAlertTriggerInterval := pAlertTriggerInterval;
        END IF;

        IF pStartTime IS NULL THEN 
            nStartTime := oStartTime;
        ELSEIF pStartTime = '' THEN   
            -- defaulted null
            nStartTime := NULL;
        ELSE
            nStartTime := pStartTime;
        END IF;

        IF pEndTime IS NULL THEN 
            nEndTime := oEndTime;
        ELSEIF pEndTime  = '' THEN   
            -- defaulted null
        ELSE
            nEndTime := pEndTime;
        END IF;

        IF pAlertDuration IS NULL THEN 
            nAlertDuration := oAlertDuration;
        ELSE
            nAlertDuration := pAlertDuration;
        END IF;

        -- start the update
        UPDATE 
            rule
        SET
            identification = nIdentification
            , type = nType
            , start_time = nStartTime
            , end_time = nEndTime
            , activity_type = nActivityType
            , activity_name = nActivityName
            , alert_duration = nAlertDuration
            , alert_trigger_interval = nAlertTriggerInterval
        WHERE
            rule_id = pRule;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;