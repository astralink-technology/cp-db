-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_enterprise' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_enterprise(
    pEnterpriseId varchar(32) 
    , pName varchar(32)
    , pCode varchar(64)
    , pDescription text
    , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    nName varchar(32);
    nCode varchar(64);
    nDescription text;
    nLastUpdate timestamp without time zone;

    oName varchar(32);
    oCode varchar(64);
    oDescription text;
    oLastUpdate timestamp without time zone;
BEGIN
    -- Enterprise ID is needed if not return
    IF pEnterpriseId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
              e.name
            , e.code
            , e.description
            , e.last_update
        INTO STRICT
            oName 
            , oCode 
            , oDescription 
            , oLastUpdate 
        FROM enteprise e WHERE 
            e.enterprise_id = pEnterpriseId;

        -- Start the updating process
        IF pName IS NULL THEN 
            nName := oName;
        ELSEIF pFirstName = '' THEN  
            nName := NULL;
        ELSE
            nName := pName;
        END IF;

        IF pCode IS NULL THEN 
            nCode := oCode;
        ELSEIF pFirstCode = '' THEN  
            nCode := NULL;
        ELSE
            nCode := pCode;
        END IF;

        IF pDescription IS NULL THEN 
            nDescription := oDescription;
        ELSEIF pFirstDescription = '' THEN  
            nDescription := NULL;
        ELSE
            nDescription := pDescription;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            enteprise
        SET 
            name = nName
            , code = nCode
            , description = nDescription
            , last_update = nLastUpdate
        WHERE 
            enterprise_id = pEnterpriseId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;