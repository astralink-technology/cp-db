-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_log' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
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
