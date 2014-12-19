-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_feature' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_feature(
        pFeatureId varchar(32)
        , pRemoteDoor varchar(32)
        , pLocalDoor varchar(32)
        , pExtensionDoor varchar(32)
        , pVoicemail varchar(32)
        , pVoicemailExtension varchar(32)
        , pPickup varchar(32)
        , pExtra1 varchar(32)
        , pExtra2 varchar(32)
        , pExtra3 varchar(32)
        , pExtra4 varchar(32)
        , pOwnerId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
  feature_id varchar(32)
  , remote_door varchar(32)
  , local_door varchar(32)
  , extension_door varchar(32)
  , voicemail varchar(32)
  , voicemail_password varchar(32)
  , voicemail_extension varchar(32)
  , pickup varchar(32)
  , extra1 varchar(32)
  , extra2 varchar(32)
  , extra3 varchar(32)
  , extra4 varchar(32)
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
    FROM feature;

    -- create a temp table to get the data
    CREATE TEMP TABLE feature_init AS
      SELECT
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
          , totalRows
          FROM feature f WHERE (
           ((pFeatureId IS NULL) OR (f.feature_id = pFeatureId)) AND
           ((pRemoteDoor IS NULL) OR (f.remote_door = pRemoteDoor)) AND
           ((pLocalDoor IS NULL) OR (f.local_door = pLocalDoor)) AND
           ((pExtensionDoor IS NULL) OR (f.extension_door = pExtensionDoor)) AND
           ((pVoicemail IS NULL) OR (f.voicemail = pVoicemail)) AND
           ((pVoicemailExtension IS NULL) OR (f.voicemail_extension = pVoicemailExtension)) AND
           ((pPickup IS NULL) OR (f.pickup = pPickup)) AND
           ((pExtra1 IS NULL) OR (f.extra1 = pExtra1)) AND
           ((pExtra2 IS NULL) OR (f.extra2 = pExtra2)) AND
           ((pExtra3 IS NULL) OR (f.extra3 = pExtra3)) AND
           ((pExtra4 IS NULL) OR (f.extra4 = pExtra4)) AND
           ((pOwnerId IS NULL) OR (f.owner_id = pOwnerId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM access_init;
END;
$BODY$
LANGUAGE plpgsql;