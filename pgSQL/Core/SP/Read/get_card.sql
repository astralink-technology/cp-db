-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_card' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_card(
    pCardId varchar(32)
  , pCardSerial varchar(32)
  , pType CHAR(1)
  , pOwnerId varchar(32)
  , pPageSize integer
  , pSkipSize integer
)
  RETURNS TABLE(
  card_id varchar(32),
  card_serial varchar(32),
  type CHAR(1),
  owner_id varchar(32),
  totalRows integer
  )
AS
  $BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM card;

    -- create a temp table to get the data
    CREATE TEMP TABLE card_init AS
      SELECT
        c.card_id
        , c.card_serial
        , c.type
        , c.owner_id
          FROM card c WHERE (
           ((pCardId IS NULL) OR (c.card_id = pCardId)) AND
           ((pCardSerial IS NULL) OR (c.card_serial = pCardSerial)) AND
           ((pType IS NULL) OR (c.type = pType)) AND
           ((pOwnerId IS NULL) OR (c.owner_id = pOwnerId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM card_init;
END;
$BODY$
LANGUAGE plpgsql;