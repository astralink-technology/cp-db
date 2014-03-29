-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_device(
	pDeviceId varchar(32)
	, pName varchar(32)
	, pCode varchar(32)
	, pStatus char(1)
	, pType char(1)
	, pType2 char(1)
	, pDescription text
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
	, pEntityId varchar(32)
);
-- Start function
CREATE FUNCTION add_device(
	pDeviceId varchar(32)
	, pName varchar(32)
	, pCode varchar(32)
	, pStatus char(1)
	, pType char(1)
	, pType2 char(1)
	, pDescription text
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
	, pOwnerId varchar(32)
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
    );
    RETURN pDeviceId;
END;
$BODY$
LANGUAGE plpgsql;
