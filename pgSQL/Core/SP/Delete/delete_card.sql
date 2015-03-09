-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_card' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_card(
  pCardId varchar(32)
)
  RETURNS BOOLEAN AS
  $BODY$
BEGIN
-- Card ID is needed if not return
    IF pCardId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from card where
        card_id = pCardId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;