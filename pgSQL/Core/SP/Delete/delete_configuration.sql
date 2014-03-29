-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS delete_configuration(
        pConfigurationId varchar(32)
);
-- Start function
CREATE FUNCTION delete_configuration(
        pConfigurationId varchar(32)
)
RETURNS BOOLEAN AS 
$BODY$
BEGIN
-- Configuration ID is needed if not return
    IF pConfigurationId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from configuration where 
        configuration_id = pConfigurationId;
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;