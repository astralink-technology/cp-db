-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_door_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_door_relationship(
        pDoorRelationshipId varchar(32)
        , pDoorId varchar(32)
        , pDeviceId varchar(32)
)
RETURNS BOOL AS
$BODY$
DECLARE
      oDoorId varchar(32);
      oDeviceId varchar(32);

      nDoorId varchar(32);
      nDeviceId varchar(32);
BEGIN
    -- Door Relationship ID is needed if not return
    IF pDoorRelationshipId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            dr.door_id
            , dr.device_id
        INTO STRICT
            oDoorId
            , oDeviceId
        FROM door d WHERE
            d.door_relationship_id = pDoorRelationshipId;

        -- Start the updating process
        IF pDoorId IS NULL THEN
            nDoorId := oDoorId;
        ELSEIF pDoorId = '' THEN
            -- defaulted null
            nDoorId := NULL;
        ELSE
            nDoorId := pDoorId;
        END IF;

        IF pDeviceId IS NULL THEN
            nDeviceId := oDeviceId;
        ELSEIF pDeviceId = '' THEN
            -- defaulted null
            nDeviceId := NULL;
        ELSE
            nDeviceId := pDeviceId;
        END IF;

        -- start the update
        UPDATE
            door_relationship
        SET
            door_id = nDoorId
            , device_id = nDeviceId
        WHERE
            door_relationship_id = pDoorRelationshipId;

        RETURN TRUE;

    END IF;
END;
$BODY$
LANGUAGE plpgsql;