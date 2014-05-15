-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_entity_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_entity_relationship(
	pEntityRelationshipId varchar(32), 
	pEntityId varchar(32), 
	pRelatedId varchar(32), 
	pStatus char(1)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oEntityId varchar(32);
    oRelatedId varchar(32);
    oStatus char(1);

    nEntityId varchar(32);
    nRelatedId varchar(32);
    nStatus char(1);
BEGIN
    -- Authentication ID is needed if not return
    IF pEntityRelationshipId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            er.entity_id 
            , er.related_id
            , er.status
        INTO STRICT
            oEntityId
            , oRelatedId  
            , oStatus
        FROM entity_relationship er WHERE 
            er.entity_relationship_id = pEntityRelationshipId;

        -- Start the updating process
        IF pEntityId IS NULL THEN 
            nEntityId := oEntityId;
        ELSEIF pEntityId = '' THEN  
            nEntityId := NULL;
        ELSE
            nEntityId := pEntityId;
        END IF;

        IF pRelatedId IS NULL THEN 
            nRelatedId := oRelatedId;
        ELSEIF pRelatedId = '' THEN   
            nRelatedId := NULL;
        ELSE
            nRelatedId := pRelatedId;
        END IF;

        IF pStatus IS NULL THEN 
            nStatus := oStatus;
        ELSEIF pStatus  = '' THEN   
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;


        -- start the update
        UPDATE 
            entity_relationship
        SET 
            entity_id = nEntityId
            , related_id = nRelatedId
            , status = nStatus
        WHERE 
            entity_relationship_id = pEntityRelationshipId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
