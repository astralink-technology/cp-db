-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_card' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_card(
    pCardId varchar(32)
  , pCardSerial varchar(32)
  , pType CHAR(1)
  , pOwnerId varchar(32)
)
  RETURNS varchar(32) AS
  $BODY$
BEGIN
    INSERT INTO card (
        card_id
        , card_serial
        , type
        , owner_id
    ) VALUES(
        pCardId
        , pCardSerial
        , pType
        , pOwnerId
    );
    RETURN pCardId;
END;
$BODY$
LANGUAGE plpgsql;