-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_cloud_access' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_cloud_access(
      pCloudAccessId varchar(32)
      , pSecret varchar(32)
      , pExtraData text
      , pExtraDateTime timestamp without time zone
      , pLastUpdate timestamp without time zone
      , pToken text
      , pType varchar(4)
)
RETURNS BOOL AS
$BODY$
DECLARE
      oCloudAccessId varchar(32);
      oSecret varchar(32);
      oExtraData text;
      oExtraDateTime timestamp without time zone;
      oLastUpdate timestamp without time zone;
      oToken text;
      oType varchar(4);

      nCloudAccessId varchar(32);
      nSecret varchar(32);
      nExtraData text;
      nExtraDateTime timestamp without time zone;
      nLastUpdate timestamp without time zone;
      nToken text;
      nType varchar(4);
BEGIN
    -- Rule ID is needed if not return
    IF pCloudAccessId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            ca.cloud_access_id
            , ca.secret
            , ca.extra_data
            , ca.extra_date_time
            , ca.last_update
            , ca.token
        INTO STRICT
            oCloudAccessId
            , oSecret
            , oExtraData
            , oExtraDateTime
            , oLastUpdate
            , oToken
        FROM cloud_access ca WHERE
            ca.cloud_access_Id = pCloudAccessId;

        -- Start the updating process
        IF pSecret IS NULL THEN
            nSecret := oSecret;
        ELSEIF pSecret = '' THEN
            -- defaulted null
            nSecret := NULL;
        ELSE
            nSecret := pSecret;
        END IF;
        
        IF pExtraData IS NULL THEN
            nExtraData := oExtraData;
        ELSEIF pExtraData = '' THEN
            -- defaulted null
            nExtraData := NULL;
        ELSE
            nExtraData := pExtraData;
        END IF;
        
        IF pExtraDateTime IS NULL THEN
            nExtraDateTime := oExtraDateTime;
        ELSEIF pExtraDateTime = '' THEN
            -- defaulted null
            nExtraDateTime := NULL;
        ELSE
            nExtraDateTime := pExtraDateTime;
        END IF;
        
        IF pToken IS NULL THEN
            nToken := oToken;
        ELSEIF pToken = '' THEN
            -- defaulted null
            nToken := NULL;
        ELSE
            nToken := pToken;
        END IF;

        IF pType IS NULL THEN
            nType := oType;
        ELSEIF pType = '' THEN
            -- defaulted null
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pLastUpdate IS NULL THEN
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            cloud_access
        SET
            secret = nSecret
            , extra_data = nExtraData
            , extra_date_time = nExtraDateTime
            , last_update = nLastUpdate
            , token = nToken
            , type = nType
        WHERE
            cloud_access_id = pCloudAcessId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;