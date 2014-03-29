-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_log(
        pLogId varchar(32)
);
-- Start function
CREATE FUNCTION delete_log(
        pLogId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Log ID is needed if not return
    IF pLogId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from log where 
        log_id = pLogId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;