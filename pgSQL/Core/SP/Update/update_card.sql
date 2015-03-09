-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_card' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_card(
    pCardId varchar(32)
  , pCardSerial varchar(32)
  , pType CHAR(1)
)
  RETURNS BOOL AS
  $BODY$
DECLARE
    oCardSerial varchar(32);
    oType CHAR(1);

    nCardSerial varchar(32);
    nType CHAR(1);
BEGIN
    -- Rule ID is needed if not return
    IF pCardId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            c.card_serial
        INTO STRICT
          oCardSerial
        FROM card c WHERE
            c.card_id = pCardId;

        -- Start the updating process
        IF pCardSerial IS NULL THEN
          nCardSerial := oCardSerial;
        ELSEIF pCardSerial = '' THEN
            -- defaulted null
          nCardSerial := NULL;
        ELSE
          nCardSerial := pCardSerial;
        END IF;
        
        IF pType IS NULL THEN
          nType := oType;
        ELSEIF pType = '' THEN
            -- defaulted null
          nType := NULL;
        ELSE
          nType := pType;
        END IF;


        -- start the update
        UPDATE
            card
        SET
            card_serial = nCardSerial
            , type = nType
        WHERE
            card_id = pCardId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;