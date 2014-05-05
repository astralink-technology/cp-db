-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS migrate_device_value_to_device_relationship_value();
-- Start function
CREATE FUNCTION migrate_device_value_to_device_relationship_value()
RETURNS BOOL AS
$BODY$
DECLARE

BEGIN
      
      RETURN TRUE;
END;
$BODY$
LANGUAGE plpgsql;