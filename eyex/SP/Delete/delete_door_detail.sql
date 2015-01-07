-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_door_detail' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_door_detail(
        pDoorId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Door ID is needed if not return
    IF pDoorId  IS NULL THEN
        RETURN FALSE;
    ELSE
        -- delete the door
        DELETE FROM door WHERE
        door_id = pDoorId;

        -- delete the door relationship
        DELETE FROM door_relationship WHERE
        door_id = pDoorId;

        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;