-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_feature' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_feature(
        pFeatureId varchar(32)
        , pRemoteDoor varchar(32)
        , pLocalDoor varchar(32)
        , pExtensionDoor varchar(32)
        , pVoicemail varchar(32)
        , pVoicemailPassword varchar(32)
        , pVoicemailExtension varchar(32)
        , pPickup varchar(32)
        , pExtra1 varchar(32)
        , pExtra2 varchar(32)
        , pExtra3 varchar(32)
        , pExtra4 varchar(32)
        , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
      oRemoteDoor varchar(32);
      oLocalDoor varchar(32);
      oExtensionDoor varchar(32);
      oVoicemail varchar(32);
      oVoicemailPassword varchar(32);
      oVoicemailExtension varchar(32);
      oPickup varchar(32);
      oExtra1 varchar(32);
      oExtra2 varchar(32);
      oExtra3 varchar(32);
      oExtra4 varchar(32);
      oLastUpdate timestamp without time zone;

      nRemoteDoor varchar(32);
      nLocalDoor varchar(32);
      nExtensionDoor varchar(32);
      nVoicemail varchar(32);
      nVoicemailPassword varchar(32);
      nVoicemailExtension varchar(32);
      nPickup varchar(32);
      nExtra1 varchar(32);
      nExtra2 varchar(32);
      nExtra3 varchar(32);
      nExtra4 varchar(32);
      nLastUpdate timestamp without time zone;
BEGIN
    -- Feature ID is needed if not return
    IF pFeatureId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            f.remote_door
            , f.local_door
            , f.extension_door
            , f.voicemail
            , f.voicemail_password
            , f.voicemail_extension
            , f.pickup
            , f.extra1
            , f.extra2
            , f.extra3
            , f.extra4
            , f.last_update
        INTO STRICT
            oRemoteDoor
            , oLocalDoor
            , oExtensionDoor
            , oVoicemail
            , oVoicemailPassword
            , oVoicemailExtension
            , oPickup
            , oExtra1
            , oExtra2
            , oExtra3
            , oExtra4
            , oLastUpdate
        FROM feature f WHERE
            f.feature_id = pFeatureId;

        -- Start the updating process
        IF pRemoteDoor IS NULL THEN 
            nRemoteDoor := oRemoteDoor;
        ELSE
            nRemoteDoor := pRemoteDoor;
        END IF;
        
        IF pLocalDoor IS NULL THEN 
            nLocalDoor := oLocalDoor;
        ELSE
            nLocalDoor := pLocalDoor;
        END IF;
        
        IF pExtensionDoor IS NULL THEN 
            nExtensionDoor := oExtensionDoor;
        ELSEIF pExtensionDoor = '' THEN   
            -- defaulted null
            nExtensionDoor := NULL;
        ELSE
            nExtensionDoor := pExtensionDoor;
        END IF;
        
        IF pVoicemail IS NULL THEN 
            nVoicemail := oVoicemail;
        ELSEIF pVoicemail = '' THEN   
            -- defaulted null
            nVoicemail := NULL;
        ELSE
            nVoicemail := pVoicemail;
        END IF;
        
        IF pVoicemailPassword IS NULL THEN 
            nVoicemailPassword := oVoicemailPassword;
        ELSEIF pVoicemailPassword = '' THEN   
            -- defaulted null
            nVoicemailPassword := NULL;
        ELSE
            nVoicemailPassword := pVoicemailPassword;
        END IF;
        
        IF pVoicemailExtension IS NULL THEN 
            nVoicemailExtension := oVoicemailExtension;
        ELSEIF pVoicemailExtension = '' THEN   
            -- defaulted null
            nVoicemailExtension := NULL;
        ELSE
            nVoicemailExtension := pVoicemailExtension;
        END IF;
        
        IF pPickup IS NULL THEN 
            nPickup := oPickup;
        ELSEIF pPickup = '' THEN   
            -- defaulted null
            nPickup := NULL;
        ELSE
            nPickup := pPickup;
        END IF;
        
        IF pExtra1 IS NULL THEN 
            nExtra1 := oExtra1;
        ELSEIF pExtra1 = '' THEN   
            -- defaulted null
            nExtra1 := NULL;
        ELSE
            nExtra1 := pExtra1;
        END IF;
        
        IF pExtra2 IS NULL THEN 
            nExtra2 := oExtra2;
        ELSEIF pExtra2 = '' THEN   
            -- defaulted null
            nExtra2 := NULL;
        ELSE
            nExtra2 := pExtra2;
        END IF;
        
        IF pExtra3 IS NULL THEN 
            nExtra3 := oExtra3;
        ELSEIF pExtra3 = '' THEN   
            -- defaulted null
            nExtra3 := NULL;
        ELSE
            nExtra3 := pExtra3;
        END IF;
        
        IF pExtra4 IS NULL THEN 
            nExtra4 := oExtra4;
        ELSEIF pExtra4 = '' THEN   
            -- defaulted null
            nExtra4 := NULL;
        ELSE
            nExtra4 := pExtra4;
        END IF;
        
        IF pLastUpdate IS NULL THEN
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            feature
        SET
            remote_door = nRemoteDoor
            , local_door = nLocalDoor
            , extension_door = nExtensionDoor
            , voicemail = nVoicemail
            , voicemail_password = nVoicemailPassword
            , voicemail_extension = nVoicemailExtension
            , pickup = nPickup
            , extra1 = nExtra1
            , extra2 = nExtra2
            , extra3 = nExtra3
            , extra4 = nExtra4
            , last_update = nLastUpdate
        WHERE
            feature_id = pFeatureId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;