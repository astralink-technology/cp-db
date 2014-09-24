-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_extension' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_extension(
        pExtensionId varchar(32)
        , pExtension integer
        , pOwnerId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
    extension_id varchar(32),
    extension integer,
    last_update timestamp without time zone,
    create_date timestamp without time zone,
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
    FROM extension;

    -- create a temp table to get the data
    CREATE TEMP TABLE extension_init AS
      SELECT
        e.extension_id
        , e.extension
        , e.create_date
        , e.last_update
        , e.owner_id
          FROM extension e WHERE (
           ((pExtensionId IS NULL) OR (e.extension_id = pExtensionId)) AND
           ((pExtension IS NULL) OR (e.extension = pExtension)) AND
           ((pOwnerId IS NULL) OR (e.owner_id = pOwnerId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM extension_init;
END;
$BODY$
LANGUAGE plpgsql;