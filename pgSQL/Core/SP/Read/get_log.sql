-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS get_log(
	pLogId varchar(32)
	, pMessage text
	, pTitle varchar(32)
	, pType char(1)
	, pLogUrl text
	, pStatus char(1)
	, pOwnerId varchar(32)
	, pPageSize integer
	, pSkipSize integer
);
-- Start function
CREATE FUNCTION get_log(
	pLogId varchar(32)
	, pMessage text
	, pTitle varchar(32)
	, pType char(1)
	, pLogUrl text 
	, pStatus char(1)
	, pOwnerId varchar(32)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	log_id varchar(32)
	, message text
	, title varchar(32)
	, type char(1)
	, log_url text 
	, status char(1)
	, create_date timestamp without time zone
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
    FROM log l WHERE (
      ((pLogId IS NULL) OR (l.log_id = pLogId)) AND
      ((pMessage IS NULL) OR (l.message = pMessage)) AND
      ((pTitle IS NULL) OR (l.title = pTitle))AND
      ((pType IS NULL) OR (l.type = pType))AND
      ((pLogUrl IS NULL) OR (l.log_url = pLogUrl))AND
      ((pStatus IS NULL) OR (l.status = pStatus)) AND
      ((pOwnerId IS NULL) OR (l.owner_id = pOwnerId))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE log_init AS
      SELECT
        l.log_id
        , l.message
        , l.title
        , l.type
        , l.log_url
        , l.status
        , l.create_date
        , l.owner_id
      FROM log l WHERE (
        ((pLogId IS NULL) OR (l.log_id = pLogId)) AND
        ((pMessage IS NULL) OR (l.message = pMessage)) AND
        ((pTitle IS NULL) OR (l.title = pTitle))AND
        ((pType IS NULL) OR (l.type = pType))AND
        ((pLogUrl IS NULL) OR (l.log_url = pLogUrl))AND
        ((pStatus IS NULL) OR (l.status = pStatus)) AND
        ((pOwnerId IS NULL) OR (l.owner_id = pOwnerId))
      )
      ORDER BY l.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM log_init;
END;
$BODY$
LANGUAGE plpgsql;
