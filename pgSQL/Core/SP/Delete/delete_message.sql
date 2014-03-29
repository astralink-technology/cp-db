-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_message(
        pMessageId varchar(32)
);
-- Start function
CREATE FUNCTION delete_message(
        pMessageId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Message ID is needed if not return
    IF pMessageId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from message where 
        message_id = pMessageId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
