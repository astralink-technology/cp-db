-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_door' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_door(
        pDoorId varchar(32)
        , pDoorName varchar(64)
        , pDoorNode integer
        , pOwnerId varchar(32)
        , pLastUpdate timestamp without time zone
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO door (
        door_id
        , door_name
        , door_node
        , owner_id
        , last_update
    ) VALUES(
        pDoorId
        , pDoorName
        , pDoorNode
        , pOwnerId
        , pLastUpdate
    );
    RETURN pDoorId;
END;
$BODY$
LANGUAGE plpgsql;