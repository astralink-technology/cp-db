-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_configuration(
	pConfigurationId varchar(32) 
	, pName varchar(64)
  , pFileUrl text
  , pValue varchar(64)
  , pValue2 varchar(64)
  , pValue3 varchar(64)
  , pValueHash varchar(60)
	, pValue2Hash varchar(60)
	, pValue3Hash varchar(60)
	, pDescription text
	, pType char(1)
  , pEnterpriseId varchar(32)
	, pCreateDate timestamp without time zone
	, pLastUpdate timestamp without time zone
);
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