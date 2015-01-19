-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_room_value' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_room_value(
        pRoomValueId varchar(32)
        , pName varchar(128)
        , pType varchar(4)
        , pStatus char(1)
        , pValue varchar(64)
        , pIntValue decimal
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO room (
        room_value_id
        , name
        , type
        , status
        , value
        , int_value
    ) VALUES(
        pRoomValueId
        , pRoomName
        , pType
        , pStatus
        , pValue
        , pIntValue
    );
    RETURN pRoomId;
END;
$BODY$
LANGUAGE plpgsql;