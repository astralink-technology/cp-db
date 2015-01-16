-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_room' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_room(
        pRoomId varchar(32)
        , pRoomNumber varchar(64)
        , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO room (
        room_id
        , room_number
        , owner_id
    ) VALUES(
        pRoomId
        , pRoomNumber
        , pOwnerId
    );
    RETURN pRoomId;
END;
$BODY$
LANGUAGE plpgsql;