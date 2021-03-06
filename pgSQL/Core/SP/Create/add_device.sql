-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_device' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_device(
	pDeviceId varchar(32)
	, pName varchar(32)
	, pCode varchar(32)
	, pStatus char(1)
	, pType varchar(4)
	, pType2 varchar(4)
	, pDescription text
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
	, pOwnerId varchar(32)
	, pDeploymentDate date
)
RETURNS varchar(32) AS
$BODY$
BEGIN
    INSERT INTO device(
      device_id
      , name
      , code
      , status
      , type
      , type2
      , description
      , create_date
      , last_update
      , owner_id
      , deployment_date
    ) VALUES(
	    pDeviceId
      , pName
      , pCode
      , pStatus
      , pType
      , pType2
      , pDescription
      , pCreateDate
      , pLastUpdate
      , pOwnerId
      , pDeploymentDate
    );
    RETURN pDeviceId;
END;
$BODY$
LANGUAGE plpgsql;
