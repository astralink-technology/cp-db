-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_external_access' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_external_access(
      pExternalAccessId varchar(32)
      , pUniqueIdentifier varchar(32)
      , pOwnerId varchar(32)
      , pEnterpriseId varchar(32)
)
RETURNS BOOL AS 
$BODY$
DECLARE
     nUniqueIdentifier varchar(32);
     nOwnerId varchar(32);
     nEnterpriseId varchar(32);

     oUniqueIdentifier varchar(32);
     oOwnerId varchar(32);
     oEnterpriseId varchar(32);
BEGIN
    -- External Access ID is needed if not return
    IF pExternalAccessId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            unique_identifier
            , owner_id
            , enterprise_id
        INTO STRICT
           oUniqueIdentifier
           , oOwnerId
           , oEnterpriseId
        FROM external_access ea WHERE
            ea.external_acess_id = pExternalAccessId;

        -- Start the updating process
        IF pUniqueIdentifier IS NULL THEN 
            nUniqueIdentifier := oUniqueIdentifier;
        ELSEIF pFirstUniqueIdentifier = '' THEN  
            nUniqueIdentifier := NULL;
        ELSE
            nUniqueIdentifier := pUniqueIdentifier;
        END IF;

        IF pOwnerId IS NULL THEN
            nOwnerId := oOwnerId;
        ELSEIF pFirstOwnerId = '' THEN
            nOwnerId := NULL;
        ELSE
            nOwnerId := pOwnerId;
        END IF;

        IF pEnterpriseId IS NULL THEN
            nEnterpriseId := oEnterpriseId;
        ELSEIF pFirstEnterpriseId = '' THEN
            nEnterpriseId := NULL;
        ELSE
            nEnterpriseId := pEnterpriseId;
        END IF;

        -- start the update
        UPDATE 
            external_access
        SET 
            unique_identifier = nUniquerIdentifier
            , owner_id = nOwnerId
            , enterprise_id = nEnterpriseId
        WHERE 
            external_access_id = pExternalAccessId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;