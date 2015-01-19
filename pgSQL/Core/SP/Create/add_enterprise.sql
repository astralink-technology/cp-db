-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_enterprise' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_enterprise(
	pEnterpriseId varchar(32) 
        , pName varchar(32)
        , pCode varchar(64)
        , pDescription text
        , pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO enterprise (
	      enterprise_id
        , name
        , code
        , description
        , create_date
	      , last_update
    ) VALUES(
	pEnterpriseId
        , pName
        , pCode
        , pDescription
        , pCreateDate
	, pLastUpdate
    );
    RETURN pEnterpriseId;
END;
$BODY$
LANGUAGE plpgsql;