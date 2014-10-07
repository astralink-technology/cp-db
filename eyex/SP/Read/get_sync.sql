-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_sync' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_sync(
        pSyncId varchar(32)
        , pSyncMaster boolean
        , pSyncExtensions boolean
        , pSyncProfile boolean
        , pSyncIvrs boolean
        , pSyncAnnouncements boolean
        , pSyncPin boolean
        , pSyncEmployeeProfile boolean
        , pOwnerId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
      sync_id varchar(32)
      , sync_master boolean
      , sync_extensions boolean
      , sync_profile boolean
      , sync_ivrs boolean
      , sync_announcements boolean
      , sync_pin boolean
      , sync_employee_profile boolean
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
    FROM sync;

    -- create a temp table to get the data
    CREATE TEMP TABLE sync_init AS
      SELECT
        s.sync_id
        , s.sync_master
        , s.sync_extensions
        , s.sync_profile
        , s.sync_ivrs
        , s.sync_announcements
        , s.sync_pin
        , s.sync_employee_profile
        , s.create_date
        , s.last_update
        , s.owner_id
      FROM sync s WHERE (
       ((pSyncId IS NULL) OR (s.sync_id = pSyncId)) AND
       ((pSyncMaster IS NULL) OR (s.sync_master = pSyncMaster)) AND
       ((pSyncExtensions IS NULL) OR (s.sync_extensions = pSyncExtensions)) AND
       ((pSyncProfile IS NULL) OR (s.sync_profile = pSyncProfile)) AND
       ((pSyncIvrs IS NULL) OR (s.sync_ivrs = pSyncIvrs)) AND
       ((pSyncAnnouncements IS NULL) OR (s.sync_announcements = pSyncAnnouncements)) AND
       ((pSyncPin IS NULL) OR (s.sync_pin = pSyncPin)) AND
       ((pSyncEmployeeProfile IS NULL) OR (s.sync_employee_profile = pSyncEmployeeProfile)) AND
       ((pOwnerId IS NULL) OR (s.owner_id = pOwnerId))
      )
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM sync_init;
END;
$BODY$
LANGUAGE plpgsql;