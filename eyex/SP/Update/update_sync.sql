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
        , pSyncExtensions bool
        , pSyncProfile bool
        , pSyncIvrs bool
        , pSyncAnnouncements bool
        , pSyncPin bool
        , pSyncEmployeeProfile bool
        , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oSyncMaster bool;
    oSyncExtensions bool;
    oSyncProfile bool;
    oSyncIvrs bool;
    oSyncAnnouncements bool;
    oSyncPin bool;
    oSyncEmployeeProfile bool;
    oLastUpdate timestamp without time zone;

    nSyncMaster bool;
    nSyncExtensions bool;
    nSyncProfile bool;
    nSyncIvrs bool;
    nSyncAnnouncements bool;
    nSyncPin bool;
    nSyncEmployeeProfile bool;
    nLastUpdate timestamp without time zone;
BEGIN
    -- Rule ID is needed if not return
    IF pSyncId IS NULL AND pOwnerId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            s.sync_master
            , s.sync_extensions
            , s.sync_profile
            , s.sync_ivrs
            , s.sync_announcements
            , s.sync_pin
            , s.sync_employee_profile
            , s.last_update
        INTO STRICT
            oSyncMaster
            , oSyncExtensions
            , oSyncProfile
            , oSyncIvrs
            , oSyncAnnouncements
            , oSyncPin
            , oSyncEmployeeProfile
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

        IF pSyncExtensions IS NULL THEN
            nSyncExtensions = oSyncExtensions;
        ELSE
            nSyncExtensions = pSyncExtensions;
        END IF;
      
        IF pSyncEmployeeProfile IS NULL THEN
            nSyncEmployeeProfile = oSyncEmployeeProfile;
        ELSE
            nSyncEmployeeProfile = pSyncEmployeeProfile;
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
        
        IF pSyncPin IS NULL THEN
            nSyncPin = oSyncPin;
        ELSE
            nSyncPin = pSyncPin;
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
            , sync_extensions = nSyncExtensions
            , sync_profile = nSyncProfile
            , sync_ivrs = nSyncIvrs
            , sync_announcements = nSyncAnnouncements
            , sync_pin = nSyncPin
            , sync_employee_profile = nSyncEmployeeProfile
            , last_update = nLastUpdate
        WHERE
            ((pSyncId IS NULL) AND (owner_id = pOwnerId)) OR
            ((pOwnerId IS NULL) AND (sync_id = pSyncId));
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;