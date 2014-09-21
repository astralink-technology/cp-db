-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_access' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_access(
        pAccessId varchar(32)
        , pPin varchar(8)
        , pCardId text
        , pExtension integer
        , pOwnerId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
	access_id varchar(32)
	, pin varchar(8)
	, card_id text
	, extension integer
	, create_date timestamp without time zone
	, owner_id varchar(32)
	, totalRows integer
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
    FROM access;

    -- create a temp table to get the data
    CREATE TEMP TABLE access_init AS
      SELECT
        a.access_id
        , a.pin
        , a.card_id
        , a.extension
        , a.create_date
        , a.owner_id
          FROM access a WHERE (
           ((pAccessId IS NULL) OR (aa.access_id = pAccessId)) AND
           ((pPin IS NULL) OR (a.pin = pPin)) AND
           ((pExtension IS NULL) OR (a.extension = pExtension)) AND
           ((pCardId IS NULL) OR (a.card_id = pCardId)) AND
           ((pOwnerId IS NULL) OR (a.owner_id = pOwnerId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM access_int;
END;
$BODY$
LANGUAGE plpgsql;