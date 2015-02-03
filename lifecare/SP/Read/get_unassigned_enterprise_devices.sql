-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_unassigned_enterprise_devices' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_unassigned_enterprise_devices()
RETURNS TABLE(
	device_id varchar(32)
	, name varchar(32)
	, code varchar(32)
	, status char(1)
	, type varchar(4)
	, type2 varchar(4)
	, description text
	, create_date timestamp without time zone
	, last_update timestamp without time zone
	, owner_id varchar(32)
	, deployment_date date
	, entity_name varchar(32)
) AS
$BODY$
BEGIN
    RETURN QUERY
      SELECT
        d.device_id
        , d.name
        , d.code
        , d.status
        , d.type
        , d.type2
        , d.description
        , d.create_date
        , d.last_update
        , d.owner_id
        , d.deployment_date
        , e.name as entity_name
      FROM device d LEFT JOIN device_relationship dr ON dr.device_id = d.device_id
      INNER JOIN entity e ON e.entity_id = dr.owner_id WHERE
      d.owner_id IS NULL AND d.type = 'L';
END;
$BODY$
LANGUAGE plpgsql;