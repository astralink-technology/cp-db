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
      , pExtension integer
      , pOwnerId varchar(32)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oPin varchar(32);
    oCardId text;
    oExtension integer;

    nPin varchar(8);
    nCardId text;
    nExtension integer;
BEGIN
    -- Rule ID is needed if not return
    IF pAccessId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            a.pin
            , a.card_id
        INTO STRICT
            oPin
            , oCardId
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

        IF pExtension IS NULL THEN
            nExtension := oExtension;
        ELSEIF pExtension = '' THEN
            -- defaulted null
            nExtension := NULL;
        ELSE
            nExtension := pExtension;
        END IF;

        -- start the update
        UPDATE 
            access
        SET
            pin = nPin
            , card_id = nCardId
            , extension = nExtension
        WHERE
            access_id = pAccessId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;