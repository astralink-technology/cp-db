-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_access' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_access(
      pAccessId varchar(32)
      , pPin varchar(8)
      , pCardId text
      , pExtensionId varchar(32)
      , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oPin varchar(32);
    oCardId text;
    oExtensionId varchar(32);
    oLastUpdate timestamp without time zone;

    nPin varchar(8);
    nCardId text;
    nExtensionId varchar(32);
    nLastUpdate timestamp without time zone;
BEGIN
    -- Rule ID is needed if not return
    IF pAccessId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            a.pin
            , a.card_id
            , a.extension_id
        INTO STRICT
            oPin
            , oCardId
            , oExtensionId
        FROM access a WHERE
            a.access_id = pAccessId;

        -- Start the updating process
        IF pPin IS NULL THEN 
            nPin := oPin;
        ELSEIF pPin = '' THEN   
            -- defaulted null
            nPin := NULL;
        ELSE
            nPin := pPin;
        END IF;

        IF pCardId IS NULL THEN
            nCardId := oCardId;
        ELSEIF pCardId = '' THEN
            -- defaulted null
            nCardId := NULL;
        ELSE
            nCardId := pCardId;
        END IF;

        IF pExtensionId IS NULL THEN
            nExtensionId := oExtensionId;
        ELSEIF pExtensionId = '' THEN
            -- defaulted null
            nExtensionId := NULL;
        ELSE
            nExtensionId := pExtensionId;
        END IF;

        IF pLastUpdate IS NULL THEN
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            access
        SET
            pin = nPin
            , card_id = nCardId
            , extension_id = nExtensionId
            , last_update = nLastUpdate
        WHERE
            access_id = pAccessId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;