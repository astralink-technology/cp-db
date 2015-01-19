-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_sip' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
  -- Start function
  CREATE FUNCTION update_sip(
    pSipId varchar(32)
    , pUsername varchar(128)
    , pPassword text
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
  )
  RETURNS BOOL AS
  $BODY$
  DECLARE
      oUsername varchar(128);
      oPassword text;
      oLastUpdate timestamp without time zone;
      oOwnerId varchar(32);

      nUsername varchar(128);
      nPassword text;
      nLastUpdate timestamp without time zone;
      nOwnerId varchar(32);
  BEGIN
      -- ID is needed if not return
      IF pSipid IS NULL THEN
          RETURN FALSE;
      ELSE
          -- select the variables into the old variables
          SELECT
              s.username
              , s.password
              , s.last_update
              , s.owner_id
          INTO STRICT
              oUsername
              , oPassword
              , oLastUpdate
              , oOwnerId
          FROM sip s WHERE
              s.sip_id = pSipId;

          -- Start the updating process
          IF pUsername IS NULL THEN
              nUsername := oUsername;
          ELSEIF pDevice2Id = '' THEN
              nUsername := NULL;
          ELSE
              nUsername := pUsername;
          END IF;

          IF pPassword IS NULL THEN
              nPassword := oPassword;
          ELSEIF pDevice2Id = '' THEN
              nPassword := NULL;
          ELSE
              nPassword := oPassword;
          END IF;

          IF pOwnerId IS NULL THEN
              nOwnerId := oOwnerId;
          ELSEIF pDevice2Id = '' THEN
              nOwnerId := NULL;
          ELSE
              nOwnerId := oOwnerId;
          END IF;

          IF pLastUpdate IS NULL THEN
              nLastUpdate := oLastUpdate;
          ELSE
              nLastUpdate := pLastUpdate;
          END IF;

          -- start the update
          UPDATE
              sip
          SET
              username = nUsername
              , password = nPassword
              , last_update = nLastUpdate
              , owner_id = nOwnerId
          WHERE
              sip_id = pSipId;

          RETURN TRUE;

      END IF;
  END;
  $BODY$
  LANGUAGE plpgsql;