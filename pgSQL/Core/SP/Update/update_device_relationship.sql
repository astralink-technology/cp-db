-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_device_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_device_relationship(
    pDeviceRelationshipId varchar(32)
    , pDeviceId varchar(32)
    , pOwnerId varchar(32)
    , pLastUpdate timestamp without time zone
    , pAppName varchar(64)
    , pAuthorize char(1)
)
RETURNS BOOL AS
$BODY$
DECLARE
     nDeviceId varchar(32);
     nOwnerId varchar(32);
     nLastUpdate timestamp without time zone;
     nAppName varchar(64);
     nAuthorize char(1);

     oDeviceId varchar(32);
     oOwnerId varchar(32);
     oLastUpdate timestamp without time zone;
     oAppName varchar(64);
     oAuthorize char(1);
BEGIN
    -- ID is needed if not return
    IF pDeviceRelationshipId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            dr.device_id
            , dr.owner_id
            , dr.last_update
            , dr.app_name
            , dr.authorize
        INTO STRICT
            oDeviceId
            , oOwnerId
            , oLastUpdate
            , oAppName
            , oAuthorize
        FROM device_relationship dr WHERE
            dr.device_relationship_id = pDeviceRelationshipId;

        -- Start the updating process
        IF pDeviceId IS NULL THEN 
            nDeviceId := oDeviceId;
        ELSEIF pDeviceId = '' THEN  
            nDeviceId := NULL;
        ELSE
            nDeviceId := pDeviceId;
        END IF;

        IF pOwnerId IS NULL THEN
            nOwnerId := oOwnerId;
        ELSEIF pOwnerId = '' THEN
            nOwnerId := NULL;
        ELSE
            nOwnerId := pOwnerId;
        END IF;

        IF pLastUpdate IS NULL THEN
            nLastUpdate := oLastUpdate;
        ELSEIF pLastUpdate = '' THEN
            nLastUpdate := NULL;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        IF pAppName IS NULL THEN
            nAppName := oAppName;
        ELSEIF pAppName = '' THEN
            nAppName := NULL;
        ELSE
            nAppName := pAppName;
        END IF;

        IF pAuthorize IS NULL THEN
            nAuthorize := oAuthorize;
        ELSEIF pAuthorize = '' THEN
            nAuthorize := NULL;
        ELSE
            nAuthorize := pAuthorize;
        END IF;

        -- start the update
        UPDATE 
            device_relationship
        SET
            device_id = nDeviceId
            , owner_id = nOwnerId
            , last_update = nLastUpdate
            , app_name = nAppName
            , authorize = nAuthorize
        WHERE
            device_relationship_id = pDeviceRelationshipId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
