-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_email(
        pEmailId varchar(32)
);
-- Start function
CREATE FUNCTION delete_email(
        pEmailId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Email ID is needed if not return
    IF pEmailId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from email where 
        email_id = pEmailId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;