-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_room' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_room(
        pRoomId varchar(32)
        , pRoomNumber varchar(64)
)
RETURNS BOOL AS
$BODY$
DECLARE
      oRoomNumber varchar(64);

      nRoomNumber varchar(64);
BEGIN
    -- Room ID is needed if not return
    IF pRoomId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            r.room_number
        INTO STRICT
            oRoomNumber
        FROM room r WHERE
            r.room_id = pRoomId;

        -- Start the updating process
        IF pRoomNumber IS NULL THEN
            nRoomNumber := oRoomNumber;
        ELSEIF pRoomNumber = '' THEN
            -- defaulted null
            nRoomNumber := NULL;
        ELSE
            nRoomNumber := pRoomNumber;
        END IF;

        -- start the update
        UPDATE
            room
        SET
            room_number = nRoomNumber
        WHERE
            room_id = pRoomId;

        RETURN TRUE;

    END IF;
END;
$BODY$
LANGUAGE plpgsql;