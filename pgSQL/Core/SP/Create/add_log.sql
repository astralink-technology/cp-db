-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_log(
	pLogId varchar(32)
	, pMessage text
	, pTitle varchar(32)
	, pType varchar(32)
	, pLogUrl text
	, pStatus char(1)
	, pCreateDate timestamp without time zone
	, pOwnerId varchar(32)
);
-- Start function
CREATE FUNCTION add_log(
	pLogId varchar(32)
	, pMessage text
	, pTitle varchar(32)
	, pType char(1)
	, pLogUrl text
	, pStatus char(1)
	, pCreateDate timestamp without time zone
	, pOwnerId varchar(32)
	, pSnapshotValue1 varchar(16)
	, pSnapshotValue2 varchar(16)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO log(
	log_id 
	, message
	, title
	, type
	, log_url
	, status
	, create_date
	, owner_id
	, snapshot_value1
	, snapshot_value2
    ) VALUES(
	pLogId
	, pMessage
	, pTitle
	, pType
	, pLogUrl
	, pStatus 
	, pCreateDate
	, pOwnerId
	, pSnapshotValue1
	, pSnapshotValue2
    );
    RETURN pLogId;
END;
$BODY$
LANGUAGE plpgsql;
