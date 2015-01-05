-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_door' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_door(
        pDoorId varchar(32)
        , pDoorName varchar(64)
        , pDoorNode integer
        , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS
$BODY$
DECLARE
      oDoorName varchar(64);
      oDoorNode integer;
      oLastUpdate timestamp without time zone;

      nDoorName varchar(64);
      nDoorNode integer;
      nLastUpdate timestamp without time zone;
BEGIN
    -- Door ID is needed if not return
    IF pDoorId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            d.door_name
            , d.door_node
            , d.last_update
        INTO STRICT
            oDoorName
            , oDoorNode
            , oLastUpdate
        FROM door d WHERE
            d.door_id = pDoorId;

        -- Start the updating process
        IF pDoorName IS NULL THEN
            nDoorName := oDoorName;
        ELSEIF pDoorName = '' THEN
            -- defaulted null
            nDoorName := NULL;
        ELSE
            nDoorName := pDoorName;
        END IF;

        IF pDoorNode IS NULL THEN
            nDoorNode := oDoorNode;
        ELSE
            nDoorNode := pDoorNode;
        END IF;

        IF pLastUpdate IS NULL THEN
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE
            door
        SET
            door_name = nDoorName
            , door_node = nDoorNode
            , last_update = nLastUpdate
        WHERE
            door_id = pDoorId;

        RETURN TRUE;

    END IF;
END;
$BODY$
LANGUAGE plpgsql;