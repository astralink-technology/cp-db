-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_device_session(
	pDeviceId varchar(32)
	, pConnectedDeviceId varchar(32)
	, pStatus char(1)
	, pCreateDate timestamp without time zone
);
-- Start function
CREATE FUNCTION add_device_session(
	pDeviceId varchar(32)
	, pConnectedDeviceId varchar(32)
	, pStatus char(1)
	, pCreateDate timestamp without time zone
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO device_session(
      device_id
      , connected_device_id
      , status
      , create_date
    ) VALUES(
      pDeviceId
      , pConnectedDeviceId
      , pStatus
      , pCreateDate
    );
    RETURN pDeviceId;
END;
$BODY$
LANGUAGE plpgsql;
