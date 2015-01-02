-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_feature' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;

-- Start function
CREATE FUNCTION add_feature(
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
        , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO feature (
        feature_id
        , remote_door
        , local_door
        , extension_door
        , voicemail
        , voicemail_password
        , voicemail_extension
        , pickup
        , extra1
        , extra2
        , extra3
        , extra4
        , last_update
        , owner_id
    ) VALUES(
        pFeatureId
        , pRemoteDoor
        , pLocalDoor
        , pExtensionDoor
        , pVoicemail
        , pVoicemailPassword
        , pVoicemailExtension
        , pPickup
        , pExtra1
        , pExtra2
        , pExtra3
        , pExtra4
        , pLastUpdate
        , pOwnerId
    );
    RETURN pFeatureId;
END;
$BODY$
LANGUAGE plpgsql;