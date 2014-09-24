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
      , pSipHost varchar(256)
      , pSipPassword varchar(128)
      , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oSipHost varchar(256);
    oSipPassword varchar(128);
    oLastUpdate timestamp without time zone;

    nSipHost varchar(256);
    nSipPassword varchar(128);
    nLastUpdate timestamp without time zone;
BEGIN
    -- Extension ID is needed if not return
    IF pSipId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            s.sip_host
            , s.sip_password
            , s.last_update
        INTO STRICT
            oSipHost
            , oSipPassword
            , oLastUpdate
        FROM sip s WHERE
            s.sip_id = pSipId;

        -- Start the updating process
        IF pSipHost IS NULL THEN
            nSipHost := oSipHost;
        ELSEIF pSipHost = '' THEN
            -- defaulted null
            nSipHost := NULL;
        ELSE
            nSipHost := pSipHost;
        END IF;
        
        IF pSipPassword IS NULL THEN
            nSipPassword := oSipPassword;
        ELSEIF pSipPassword = '' THEN
            -- defaulted null
            nSipPassword := NULL;
        ELSE
            nSipPassword := pSipPassword;
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
            sip_host = nSipHost
            , sip_password = nSipPassword
        WHERE
            sip_id = pSipId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;