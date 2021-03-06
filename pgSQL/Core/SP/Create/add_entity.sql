-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_entity' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_entity(
	pEntityId varchar(32),
	pFirstName varchar(128),
	pLastName varchar(128),
	pNickName varchar(256),
	pName varchar(256),
	pStatus char(1),
	pApproved boolean,
	pType char(1),
	pCreateDate timestamp without time zone,
	pLastUpdate timestamp without time zone,
	pAuthenticationId varchar(32),
	pPrimaryEmailId varchar(32),
	pPrimaryPhoneId varchar(32),
	pDateEstablished timestamp without time zone,
	pDisabled boolean
)
RETURNS varchar(32) AS
$BODY$
BEGIN
    INSERT INTO entity (
	entity_id
	, first_name
	, last_name
	, nick_name
	, name
	, status
	, approved
	, type
	, create_date
	, last_update
	, authentication_id
	, primary_email_id
	, primary_phone_id
	, date_established
	, disabled
    ) VALUES(
	pEntityId
	, pFirstName
	, pLastName
	, pNickName
	, pName
	, pStatus
	, pApproved
	, pType
	, pCreateDate
	, pLastUpdate
	, pAuthenticationId
	, pPrimaryEmailId
	, pPrimaryPhoneId
	, pDateEstablished
	, pDisabled
    );
    RETURN pEntityId;
END;
$BODY$
LANGUAGE plpgsql;