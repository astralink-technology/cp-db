-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_email' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_email(
    pEmailId varchar(32)
    , pEmailAddress varchar(64)
    , pCreateDate timestamp without time zone
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO email (
	email_id 
	, email_address 
	, create_date
	, last_update
	, owner_id
    ) VALUES(
        pEmailId
        , pEmailAddress
        , pCreateDate
        , pLastUpdate
        , pOwnerId
    );
    RETURN pEmailId;
END;
$BODY$
LANGUAGE plpgsql;