-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_product' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_sip(
    pSipId varchar(32)
    , pUsername varchar(128)
    , pOwnerId varchar(32)
)
RETURNS TABLE(
    sip_id varchar(32)
    , username varchar(128)
    , password text
    , create_date timestamp without time zone
    , last_update timestamp without time zone
    , owner_id varchar(32)
) AS
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
        , s.username
        , s.password
        , s.create_date
        , s.last_update
        , s.owner_id
      FROM sip s WHERE (
        ((pSipId IS NULL) OR (s.sip_id = pSipId)) AND
        ((pUsername IS NULL) OR (s.username = pUsername)) AND
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
