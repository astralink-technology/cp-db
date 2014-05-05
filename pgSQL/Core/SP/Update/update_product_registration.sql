-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_product_registration' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_product_registration(
    pProductRegistrationId varchar(32)
    , pStatus char(1)
    , pType char(1)
    , pLastUpdate timestamp without time zone
    , pProductId varchar(32)
    , pOwnerId varchar(32)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oStatus char(1);
    oType char(1);
    oLastUpdate timestamp without time zone;
    oProductId varchar(32);
    oOwnerId varchar(32);

    nStatus char(1);
    nType char(1);
    nLastUpdate timestamp without time zone;
    nProductId varchar(32);
    nOwnerId varchar(32);
BEGIN
    -- ID is needed if not return
    IF pProductId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            pr.status
            , pr.type
            , pr.create_date
            , pr.product_id
            , pr.owner_id
        INTO STRICT
            oStatus
            , oType
            , oLastUpdate
            , oProductId
            , oOwnerId
        FROM product_registration pr WHERE 
            pr.product_registration_id = pProductRegistrationId;

        -- Start the updating process
        IF pStatus IS NULL THEN 
            nStatus := oStatus;
        ELSEIF pDevice2Id = '' THEN  
            nStatus := NULL;
        ELSE
            nStatus := oStatus;
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
        ELSEIF pDevice2Id = '' THEN
            nLastUpdate := NULL;
        ELSE
            nLastUpdate := oLastUpdate;
        END IF;

        IF pProductId IS NULL THEN 
            nProductId := oProductId;
        ELSEIF pDevice2Id = '' THEN  
            nProductId := NULL;
        ELSE
            nProductId := oProductId;
        END IF;

        IF pOwnerId IS NULL THEN 
            nOwnerId := oOwnerId;
        ELSEIF pDevice2Id = '' THEN  
            nOwnerId := NULL;
        ELSE
            nOwnerId := oOwnerId;
        END IF;

		-- start the update
        UPDATE 
            product_registration
        SET 
            status = nStatus
            , product_id = nProduct_Id
            , owner_id = nOwnerId

        WHERE 
            product_registration_id = pProductRegistrationId;
            
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;