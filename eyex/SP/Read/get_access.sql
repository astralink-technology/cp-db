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
        , pCardId text
        , pExtensionId varchar(32)
        , pOwnerId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
	access_id varchar(32)
	, card_id text
	, extension_id varchar(32)
	, create_date timestamp without time zone
	, last_update timestamp without time zone
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
        , a.card_id
        , a.extension_id
        , a.create_date
        , a.last_update
        , a.owner_id
          FROM access a WHERE (
           ((pAccessId IS NULL) OR (aa.access_id = pAccessId)) AND
           ((pExtensionId IS NULL) OR (a.extension_id = pExtensionId)) AND
           ((pCardId IS NULL) OR (a.card_id = pCardId)) AND
           ((pOwnerId IS NULL) OR (a.owner_id = pOwnerId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM access_init;
END;
$BODY$
LANGUAGE plpgsql;