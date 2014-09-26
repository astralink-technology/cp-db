-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_sync' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_sync(
        pSyncId varchar(32)
        , pSyncMaster boolean
        , pSyncExtensions boolean
        , pSyncProfile boolean
        , pSyncIvrs boolean
        , pSyncAnnouncements boolean
        , pSyncPin boolean
        , pCreateDate timestamp without time zone
        , pLastUpdate timestamp without time zone
        , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO sync (
        sync_id
        , sync_master
        , sync_extensions
        , sync_profile
        , sync_ivrs
        , sync_announcements
        , sync_pin
        , create_date
        , last_update
        , owner_id
    ) VALUES(
        pSyncId
        , pSyncMaster
        , pSyncExtensions
        , pSyncProfile
        , pSyncIvrs
        , pSyncAnnouncements
        , pSyncPin
        , pCreateDate
        , pLastUpdate
        , pOwnerId
    );
    RETURN pSyncId;
END;
$BODY$
LANGUAGE plpgsql;