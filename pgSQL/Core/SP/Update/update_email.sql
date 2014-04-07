-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_email' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_email(
    pEmailId varchar(32)
    , pEmailAddress varchar(64)
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    nEmailAddress varchar(64);
    nLastUpdate timestamp without time zone;
    nOwnerId varchar(32);

    oEmailAddress varchar(64);
    oLastUpdate timestamp without time zone;
    oOwnerId varchar(32);
BEGIN
    -- Email ID is needed if not return
    IF pEmailId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            e.email_address
            , e.last_update
            , e.owner_id
        INTO STRICT
            oEmailAddress
            , oLastUpdate
            , oOwnerId
        FROM email e WHERE 
            e.email_id = pEmailId;

        -- Start the updating process
        IF pEmailAddress IS NULL THEN 
            nEmailAddress := oEmailAddress;
        ELSEIF pFirstName = '' THEN  
            nEmailAddress := NULL;
        ELSE
            nEmailAddress := pEmailAddress;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        IF pOwnerId IS NULL THEN 
            nOwnerId := oOwnerId;
        ELSEIF pOwnerId = '' THEN  
            nOwnerId := NULL;
        ELSE
            nOwnerId := pOwnerId;
        END IF;

        -- start the update
        UPDATE 
            email
        SET 
            email_address = nEmailAddress
            , last_update = nLastUpdate
            , owner_id = nOwnerId
        WHERE 
            email_id = pEmailId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
