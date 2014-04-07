-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_configuration' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_configuration(
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
    , pSalt varchar(16)
    , pType char(1)
    , pEnterpriseId varchar(32)
    , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    nName varchar(64);
    nFileUrl text;
    nValue varchar(128);
    nValue2 varchar(128);
    nValue3 varchar(128);
    nValueHash varchar(128);
    nValue2Hash varchar(128);
    nValue3Hash varchar(128);
    nDescription text;
    nSalt varchar(16);
    nType char(1);
    nEnterpriseId varchar(32);
    nLastUpdate timestamp without time zone;

    oName varchar(64);
    oFileUrl text;
    oValue varchar(128);
    oValue2 varchar(128);
    oValue3 varchar(128);
    oValueHash varchar(128);
    oValue2Hash varchar(128);
    oValue3Hash varchar(128);
    oDescription text;
    oSalt varchar(16);
    oType char(1);
    oEnterpriseId varchar(32);
    oLastUpdate timestamp without time zone;
BEGIN
    -- Configuration ID is needed if not return
    IF pConfigurationId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            c.configuration_id
            , c.name
            , c.file_url
            , c.value
            , c.value2
            , c.value3
            , c.value_hash
            , c.value2_hash
            , c.value3_hash
            , c.description
            , c.salt 
            , c.type 
            , c.enterprise_id  
            , c.last_update
        INTO STRICT
            oName
            , oFileUrl
            , oValue
            , oValue2
            , oValue3
            , oValueHash
            , oValue2Hash
            , oValue3Hash
            , oDescription
            , oSalt
            , oType
            , oEnterpriseId 
            , oLastUpdate
        FROM configuration c WHERE 
            c.configuration_id = pConfigurationId;

        -- Start the updating process
        IF pName IS NULL THEN 
            nName := oName;
        ELSEIF pFirstName = '' THEN  
            nName := NULL;
        ELSE
            nName := pName;
        END IF;

        IF pFileUrl IS NULL THEN 
            nFileUrl := oFileUrl;
        ELSEIF pFirstFileUrl = '' THEN  
            nFileUrl := NULL;
        ELSE
            nFileUrl := pFileUrl;
        END IF;

        IF pValue IS NULL THEN
            nValue := oValue;
        ELSEIF pFirstValue = '' THEN
            nValue := NULL;
        ELSE
            nValue := pValue;
        END IF;

        IF pValue2 IS NULL THEN
            nValue2 := oValue2;
        ELSEIF pFirstValue2 = '' THEN
            nValue2 := NULL;
        ELSE
            nValue2 := pValue2;
        END IF;

        IF pValue3 IS NULL THEN
            nValue3 := oValue3;
        ELSEIF pFirstValue3 = '' THEN
            nValue3 := NULL;
        ELSE
            nValue3 := pValue3;
        END IF;
        
        IF pValueHash IS NULL THEN 
            nValueHash := oValueHash;
        ELSEIF pFirstValueHash = '' THEN  
            nValueHash := NULL;
        ELSE
            nValueHash := pValueHash;
        END IF;

        IF pValue2Hash IS NULL THEN 
            nValue2Hash := oValue2Hash;
        ELSEIF pFirstValue2Hash = '' THEN  
            nValue2Hash := NULL;
        ELSE
            nValue2Hash := pValue2Hash;
        END IF;

        IF pValue3Hash IS NULL THEN 
            nValue3Hash := oValue3Hash;
        ELSEIF pFirstValue3Hash = '' THEN  
            nValue3Hash := NULL;
        ELSE
            nValue3Hash := pValue3Hash;
        END IF;

        IF pSalt IS NULL THEN 
            nSalt := oSalt;
        ELSEIF pFirstSalt = '' THEN  
            nSalt := NULL;
        ELSE
            nSalt := pSalt;
        END IF;

        IF pDescription IS NULL THEN 
            nDescription := oDescription;
        ELSEIF pFirstDescription = '' THEN  
            nDescription := NULL;
        ELSE
            nDescription := pDescription;
        END IF;

        IF pEnterpriseId IS NULL THEN 
            nEnterpriseId := oEnterpriseId;
        ELSEIF pFirstEnterpriseId = '' THEN  
            nEnterpriseId := NULL;
        ELSE
            nEnterpriseId := pEnterpriseId;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pDevice2Id = '' THEN  
            nType := NULL;
        ELSE
            nType := oType;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            configuration
        SET 
            name = nName
            , file_url = nFileUrl
            , value = nValue
            , value2 = nValue2
            , value3 = nValue3
            , value_hash = nValueHash
            , value2_hash = nValue2Hash
            , value3_hash = nValue3Hash
            , description = nDescription
            , salt  = nSalt
            , type  = nType
            , enterprise_id = nEnterpriseId
            , last_update = nLastUpdate
        WHERE 
            configuration_id = pConfigurationId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;