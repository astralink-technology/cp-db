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
        , pSyncMaster boolean
        , pSyncSip boolean
        , pSyncExtensions boolean
        , pSyncProfile boolean
        , pSyncIvrs boolean
        , pSyncAnnouncements boolean
        , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oSyncMaster boolean;
    oSyncSip boolean;
    oSyncExtensions boolean;
    oSyncProfile boolean;
    oSyncIvrs boolean;
    oSyncAnnouncements boolean;
    oLastUpdate timestamp without time zone;

    nSyncMaster boolean;
    nSyncSip boolean;
    nSyncExtensions boolean;
    nSyncProfile boolean;
    nSyncIvrs boolean;
    nSyncAnnouncements boolean;
    nLastUpdate timestamp without time zone;
BEGIN
    -- Rule ID is needed if not return
    IF pSyncId IS NULL THEN
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
            s.sync_id = pSyncId;

        -- Start the updating process
        IF pSyncMaster IS NULL THEN 
            nSyncMaster := oSyncMaster;
        ELSEIF pSyncMaster = '' THEN   
            -- defaulted null
            nSyncMaster := NULL;
        ELSE
            nSyncMaster := pSyncMaster;
        END IF;

        IF pSyncSip IS NULL THEN
            nSyncSip := oSyncSip;
        ELSEIF pSyncSip = '' THEN
            -- defaulted null
            nSyncSip := NULL;
        ELSE
            nSyncSip := pSyncSip;
        END IF;

        IF pSyncExtensions IS NULL THEN
            nSyncExtensions := oSyncExtensions;
        ELSEIF pSyncExtensions = '' THEN
            -- defaulted null
            nSyncExtensions := NULL;
        ELSE
            nSyncExtensions := pSyncExtensions;
        END IF;

        IF pSyncProfile IS NULL THEN
            nSyncProfile := oSyncProfile;
        ELSEIF pSyncProfile = '' THEN
            -- defaulted null
            nSyncProfile := NULL;
        ELSE
            nSyncProfile := pSyncProfile;
        END IF;

        IF pSyncIvrs IS NULL THEN
            nSyncIvrs := oSyncIvrs;
        ELSEIF pSyncIvrs = '' THEN
            -- defaulted null
            nSyncIvrs := NULL;
        ELSE
            nSyncIvrs := pSyncIvrs;
        END IF;

        IF pSyncAnnouncements IS NULL THEN
            nSyncAnnouncements := oSyncAnnouncements;
        ELSEIF pSyncAnnouncements = '' THEN
            -- defaulted null
            nSyncAnnouncements := NULL;
        ELSE
            nSyncAnnouncements := pSyncAnnouncements;
        END IF;
        
        IF pLastUpdate IS NULL THEN
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            sync
        SET
            sync_master = nSyncMaster
            , sync_sip = nSyncMaster
            , sync_extensions = nSyncMaster
            , sync_extensions = nSyncMaster
            , last_update = nLastUpdate
        WHERE
            sync_id = pSyncId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;