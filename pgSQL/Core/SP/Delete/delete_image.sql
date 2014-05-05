-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_image' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_image(
        pImageId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Log ID is needed if not return
    IF pImageId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from image where 
        image_id = pImageId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
