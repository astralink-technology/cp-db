-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_enterprise_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_enterprise_relationship(
    pEnterpriseRelationshipId varchar(32)
    , pEnterpriseId varchar(32)
    , pOwnerId varchar(32)
    , pStatus char(1)
    , pType varchar(4)
    , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    nEnterpriseId varchar(32);
    nOwnerId varchar(32);
    nStatus char(1);
    nType varchar(4);
    nLastUpdate timestamp without time zone;

    oEnterpriseId varchar(32);
    oOwnerId varchar(32);
    oStatus char(1);
    oType varchar(4);
    oLastUpdate timestamp without time zone;

BEGIN
    -- Enterprise Relationship ID is needed if not return
    IF pEnterpriseRelationshipId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            enterprise_id
            , owner_id
            , status
            , type
            , last_update
        INTO STRICT
            oEnterpriseId
            , oOwnerId
            , oStatus
            , oType
            , oLastUpdate
        FROM enteprise_relationship er WHERE
            er.enterprise_relationship_id = pEnterpriseRelationshipId;

        -- Start the updating process
        IF pEnterpriseId IS NULL THEN 
            nEnterpriseId := oEnterpriseId;
        ELSEIF pFirstEnterpriseId = '' THEN  
            nEnterpriseId := NULL;
        ELSE
            nEnterpriseId := pEnterpriseId;
        END IF;

        IF pOwnerId IS NULL THEN
            nOwnerId := oOwnerId;
        ELSEIF pFirstOwnerId = '' THEN  
            nOwnerId := NULL;
        ELSE
            nOwnerId := pOwnerId;
        END IF;

        IF pStatus IS NULL THEN
            nStatus := oStatus;
        ELSEIF pFirstStatus = '' THEN  
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pFirstType = '' THEN  
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            enteprise_relationship
        SET 
            enterprise_id = nEnterpriseId
            , owner_id = nOwnerId
            , status = nStatus
            , type = nType
            , last_update = nLastUpdate
        WHERE 
            enterprise_relationship_id = pEnterpriseRelationshipId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;