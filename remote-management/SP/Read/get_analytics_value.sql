-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_dashboard' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_dashboard(
        pDashboardId varchar(32)
        , pStatus char(1)
        , pArmDisarm char(1)
        , pDeviceId  varchar(32)
        , pEntityId varchar(32)
    )
RETURNS TABLE(
	dashboard_id varchar(32)
  , snapshot text
  , status char(1)
  , arm_disarm char(1)
  , file_type varchar(16)
	, create_date timestamp without time zone
	, device_id varchar(32)
	, entity_id varchar(32)
	, device_status text
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
    FROM dashboard;

    -- create a temp table to get the data
    CREATE TEMP TABLE dashboard_init AS
      SELECT
            d.dashboard_id
            , d.snapshot
            , d.status
            , d.arm_disarm
            , d.file_type
            , d.create_date
            , d.device_id
            , d.entity_id
            , d.device_status
          FROM dashboard d WHERE (
           ((pDashboardId IS NULL) OR (d.dashboard_id = pDashboardId)) AND
           ((pStatus IS NULL) OR (d.status = pStatus)) AND
           ((pArmDisarm IS NULL) OR (d.arm_disarm = pArmDisarm)) AND
           ((pDeviceId IS NULL) OR (d.device_id = pDeviceId)) AND
           ((pEntityId IS NULL) OR (d.entity_id = pEntityId))
          )
          ORDER BY d.create_date DESC;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM dashboard_init;

END;
$BODY$
LANGUAGE plpgsql;