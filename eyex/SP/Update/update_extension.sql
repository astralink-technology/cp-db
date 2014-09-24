-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_extension' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_extension(
      pExtensionId varchar(32)
      , pExtension varchar(8)
      , pExtensionPassword varchar(128)
      , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oExtension integer;
    oExtensionPassword varchar(128);
    oLastUpdate timestamp without time zone;

    nExtension integer;
    nExtensionPassword varchar(128);
    nLastUpdate timestamp without time zone;
BEGIN
    -- Rule ID is needed if not return
    IF pExtensionId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            e.extension
        INTO STRICT
            oExtension
        FROM extension e WHERE
            e.extension_id = pExtension;

        -- Start the updating process
        IF pExtension IS NULL THEN
            nExtension := oExtension;
        ELSEIF pExtension = '' THEN
            -- defaulted null
            nExtension := NULL;
        ELSE
            nExtension := pExtension;
        END IF;
        
        IF pExtensionPassword IS NULL THEN
            nExtensionPassword := oExtensionPassword;
        ELSEIF pExtensionPassword = '' THEN
            -- defaulted null
            nExtensionPassword := NULL;
        ELSE
            nExtensionPassword := pExtensionPassword;
        END IF;

        IF pLastUpdate IS NULL THEN
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE
            extension
        SET
            extension = nExtension
            , extension_password = nExtensionPassword
            , last_update = nLastUpdate
        WHERE
            extension_id = pExtensionId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;