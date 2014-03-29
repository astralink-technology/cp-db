-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS get_email(
    pEmailId varchar(32)
    , pEmailAddress varchar(64)
    , pOwnerId varchar(32)
    , pPageSize integer
    , pSkipSize integer
);
-- Start function
CREATE FUNCTION get_email(
    pEmailId varchar(32)
    , pEmailAddress varchar(64)
    , pOwnerId varchar(32)
    , pPageSize integer
    , pSkipSize integer
)
RETURNS TABLE(
	email_id varchar(32) 
	, email_address varchar(64) 
	, create_date timestamp without time zone
	, last_update timestamp without time zone
	, owner_id varchar(32)
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
    FROM email e WHERE (
    ((pEmailId IS NULL) OR (e.email_id= pEmailId)) AND
    ((pEmailAddress IS NULL) OR (e.email_address = pEmailAddress)) AND
    ((pOwnerId IS NULL) OR (e.owner_id = pOwnerId))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE email_init AS
      SELECT
        e.email_id
        , e.email_address
        , e.create_date
        , e.last_update
        , e.owner_id
      FROM email e WHERE (
        ((pEmailId IS NULL) OR (e.email_id= pEmailId)) AND
        ((pEmailAddress IS NULL) OR (e.email_address = pEmailAddress)) AND
        ((pOwnerId IS NULL) OR (e.owner_id = pOwnerId))
        )
      ORDER BY e.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM email_init;

END;
$BODY$
LANGUAGE plpgsql;