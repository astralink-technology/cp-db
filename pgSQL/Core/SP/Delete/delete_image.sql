-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_image(
        pImageId varchar(32)
);
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
