-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_door' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_door(
        pDoorId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Door ID is needed if not return
    IF pDoorId  IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from door where
        door_id = pDoorId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;