-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_device_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_device_relationship(
	pDeviceRelationshipId varchar(32)
	, pDeviceId varchar(32)
	, pOwnerId varchar(32)
	, pLastUpdate timestamp without time zone
	, pCreateDate timestamp without time zone
	, pAppName varchar(64)
)
RETURNS varchar(32) AS
$BODY$
BEGIN
    INSERT INTO device_relationship(
      device_relationship_id
      , device_id
      , owner_id
      , last_update
      , create_date
      , app_name
    ) VALUES(
	pDeviceRelationshipId
      , pDeviceId
      , pOwnerId
      , pLastUpdate
      , pCreateDate
	, pAppName
    );
    RETURN pDeviceRelationshipId;
END;
$BODY$
LANGUAGE plpgsql;
