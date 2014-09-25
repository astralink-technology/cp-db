-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_sync' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_sync(
        pSyncId varchar(32)
        , pOwnerId varchar(32)
        , pSyncMaster bool
        , pSyncSip bool
        , pSyncExtensions bool
        , pSyncProfile bool
        , pSyncIvrs bool
        , pSyncAnnouncements bool
        , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oSyncMaster bool;
    oSyncSip bool;
    oSyncExtensions bool;
    oSyncProfile bool;
    oSyncIvrs bool;
    oSyncAnnouncements bool;
    oLastUpdate timestamp without time zone;

    nSyncMaster bool;
    nSyncSip bool;
    nSyncExtensions bool;
    nSyncProfile bool;
    nSyncIvrs bool;
    nSyncAnnouncements bool;
    nLastUpdate timestamp without time zone;
BEGIN
    -- Rule ID is needed if not return
    IF pSyncId IS NULL AND pOwnerId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            s.sync_master
            , s.sync_sip
            , s.sync_extensions
            , s.sync_profile
            , s.sync_ivrs
            , s.sync_announcements
            , s.last_update
        INTO STRICT
            oSyncMaster
            , oSyncSip
            , oSyncExtensions
            , oSyncProfile
            , oSyncIvrs
            , oSyncAnnouncements
            , oLastUpdate
        FROM sync s WHERE
            ((pSyncId IS NULL) AND (owner_id = pOwnerId)) OR
            ((pOwnerId IS NULL) AND (sync_id = pSyncId));

        -- Start the updating process
        IF pSyncMaster IS NULL THEN 
            nSyncMaster = oSyncMaster;
        ELSE
            nSyncMaster = pSyncMaster;
        END IF;

        IF pSyncSip IS NULL THEN
            nSyncSip = oSyncSip;
        ELSE
            nSyncSip = pSyncSip;
        END IF;

        IF pSyncExtensions IS NULL THEN
            nSyncExtensions = oSyncExtensions;
        ELSE
            nSyncExtensions = pSyncExtensions;
        END IF;

        IF pSyncProfile IS NULL THEN
            nSyncProfile = oSyncProfile;
        ELSE
            nSyncProfile = pSyncProfile;
        END IF;

        IF pSyncIvrs IS NULL THEN
            nSyncIvrs = oSyncIvrs;
        ELSE
            nSyncIvrs = pSyncIvrs;
        END IF;

        IF pSyncAnnouncements IS NULL THEN
            nSyncAnnouncements = oSyncAnnouncements;
        ELSE
            nSyncAnnouncements = pSyncAnnouncements;
        END IF;
        
        IF pLastUpdate IS NULL THEN
            nLastUpdate = oLastUpdate;
        ELSE
            nLastUpdate = pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            sync
        SET
            sync_master = nSyncMaster
            , sync_sip = nSyncSip
            , sync_extensions = nSyncExtensions
            , sync_profile = nSyncProfile
            , sync_ivrs = nSyncIvrs
            , sync_announcements = nSyncAnnouncements
            , last_update = nLastUpdate
        WHERE
            ((pSyncId IS NULL) AND (owner_id = pOwnerId)) OR
            ((pOwnerId IS NULL) AND (sync_id = pSyncId));
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;