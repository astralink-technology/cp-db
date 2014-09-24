-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_extension_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_extension_details(
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
    access_id varchar(32),
    name varchar(64),
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
        , a.access_id
        , ee.name
          FROM extension e
          LEFT JOIN access a ON a.extension_id = e.extension_id
          INNER JOIN entity ee ON ee.entity_id = a.owner_id WHERE (
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