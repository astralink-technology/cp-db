-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_configuration' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_configuration(
	pConfigurationId varchar(32) 
	, pName varchar(64)
  , pFileUrl text
  , pValue varchar(128)
  , pValue2 varchar(128)
  , pValue3 varchar(128)
  , pValueHash varchar(128)
	, pValue2Hash varchar(128)
	, pValue3Hash varchar(128)
	, pDescription text
	, pType char(1)
  , pEnterpriseId varchar(32)
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO configuration (
      configuration_id
      , name
      , file_url
      , value
      , value2
      , value3
      , value_hash
      , value2_hash
      , value3_hash
      , description
	    , type
      , enterprise_id
      , create_date
      , last_update
    ) VALUES(
      pConfigurationId
      , pName
      , pFileUrl
      , pValue
      , pValue2
      , pValue3
      , pValueHash
      , pValue2Hash
      , pValue3Hash
      , pDescription
	    , pType
      , pEnterpriseId
      , pCreateDate
      , pLastUpdate
    );
    RETURN pConfigurationId;
END;
$BODY$
LANGUAGE plpgsql;