-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS get_configuration(
	    pConfigurationId varchar(32)
	    , pName varchar(64)
	    , pType char(1)
      , pEnterpriseId varchar(32)
      , pPageSize integer
      , pSkipSize integer
    );
-- Start function
CREATE FUNCTION get_configuration(
	    pConfigurationId varchar(32)
	    , pName varchar(64)
	    , pType char(1)
      , pEnterpriseId varchar(32)
      , pPageSize integer
      , pSkipSize integer
    )
RETURNS TABLE(
	  configuration_id varchar(32)
	  , name varchar(64)
    , file_url text
    , value varchar(128)
    , value2 varchar(128)
    , value3 varchar(128)
    , value_hash varchar(128)
	  , value2_hash varchar(128)
	  , value3_hash varchar(128)
	  , description text
	  , type char(1)
    , enterprise_id varchar(32)
	  , create_date timestamp without time zone
	  , last_update timestamp without time zone
	  , total_rows integer
) AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM configuration c WHERE (
      ((pConfigurationId IS NULL) OR (c.configuration_id = pConfigurationId)) AND
      ((pName IS NULL) OR (c.name = pName)) AND
      ((pType IS NULL) OR (c.type = pType)) AND
      ((pEnterpriseId IS NULL) OR (c.enterprise_id = pEnterpriseId))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE configuration_init AS
      SELECT
        c.configuration_id
      , c.name
      , c.file_url
      , c.value
      , c.value2
      , c.value3
      , c.value_hash
      , c.value2_hash
      , c.value3_hash
      , c.description
      , c.type
      , c.enterprise_id
      , c.create_date
      , c.last_update
      FROM configuration c WHERE (
        ((pConfigurationId IS NULL) OR (c.configuration_id = pConfigurationId)) AND
        ((pName IS NULL) OR (c.name = pName)) AND
        ((pType IS NULL) OR (c.type = pType)) AND
        ((pEnterpriseId IS NULL) OR (c.enterprise_id = pEnterpriseId))
      )
      ORDER BY c.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM configuration_init;

END;
$BODY$
LANGUAGE plpgsql;