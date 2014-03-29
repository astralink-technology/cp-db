-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_authentication(
        pAuthenticationId varchar(32)
);
-- Start function
CREATE FUNCTION delete_authentication(
        pAuthenticationId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Authentication ID is needed if not return
    IF pAuthenticationId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from authentication where 
        authentication_id = pAuthenticationId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;