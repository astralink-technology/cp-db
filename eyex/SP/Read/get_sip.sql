-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_sip' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_sip(
        pSipId varchar(32)
        , pSipHost varchar(256)
        , pOwnerId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
    sip_id varchar(32),
    sip_host varchar(256),
    owner_id varchar(32),
    last_update timestamp without time zone,
    create_date timestamp without time zone,
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
    FROM sip;

    -- create a temp table to get the data
    CREATE TEMP TABLE sip_init AS
      SELECT
        s.sip_id
        , s.sip_host
        , s.owner_id
        , s.last_update
        , s.create_date
          FROM sip s WHERE (
           ((pSipId IS NULL) OR (s.sip_id = pSipId)) AND
           ((pSipHost IS NULL) OR (s.sip_host = pSipHost)) AND
           ((pOwnerId IS NULL) OR (s.owner_id = pOwnerId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM sip_init;
END;
$BODY$
LANGUAGE plpgsql;