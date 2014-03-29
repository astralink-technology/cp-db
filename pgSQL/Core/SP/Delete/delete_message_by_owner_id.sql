-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_message_by_owner_id(
        pOwnerId varchar(32)
);
-- Start function
CREATE FUNCTION delete_message_by_owner_id(
        pOwnerId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Device ID is needed if not return
    IF pOwnerId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from message where 
        owner_id = pOwnerId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
