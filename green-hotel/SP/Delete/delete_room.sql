-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_room' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_room(
        pRoomId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Room ID is needed if not return
    IF pRoomId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- delete the room
        DELETE FROM room WHERE
        room_id = pRoomId;

        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;