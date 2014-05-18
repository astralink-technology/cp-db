-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_rule' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_rule(
        pRuleId varchar(32)
        , pIdentification varchar(32)
        , pType char(1)
        , pActivityType varchar(32)
        , pActivityName varchar(32)
        , pZone varchar(32)
        , pOwnerId varchar(32)
    )
RETURNS TABLE(
    rule_id varchar(32)
    , identification varchar(32)
    , type char(1)
    , start_time time without time zone
    , end_time time without time zone
    , activity_type varchar(32)
    , activity_name varchar(32)
    , alert_trigger_time time without time zone
    , alert_trigger_interval interval
    , create_date timestamp without time zone
    , zone varchar(32)
    , owner_id varchar(32)
    , totalRows integer
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
    FROM rule;

    -- create a temp table to get the data
    CREATE TEMP TABLE rule_init AS
      SELECT
          r.rule_id
          , r.identification
          , r.type
          , r.start_time
          , r.end_time
          , r.activity_type
          , r.activity_name
          , r.alert_trigger_time
          , r.alert_trigger_interval
          , r.create_date
          , r.zone
          , r.owner_id
          FROM rule r WHERE
          ((pRuleId IS NULL) OR (r.rule_id = pRuleId)) AND
          ((pIdentification IS NULL) OR (r.identification = pIdentification)) AND
          ((pType IS NULL) OR (r.type = pType)) AND
          ((pActivityType IS NULL) OR (r.activity_type = pActivityType)) AND
          ((pActivityName IS NULL) OR (r.activity_name = pActivityName)) AND
          ((pZone IS NULL) OR (r.zone = pZone)) AND
          ((pOwnerId IS NULL) OR (r.owner_id = pOwnerId))
      ORDER BY r.create_date ASC;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM rule_init;

END;
$BODY$
LANGUAGE plpgsql;
