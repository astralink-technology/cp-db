-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS get_authentication(
        pAuthenticationId varchar(32)
        , pAuthenticationStringLower varchar(32)
        , pPageSize integer
        , pSkipSize integer
    );
-- Start function
CREATE FUNCTION get_authentication(
        pAuthenticationId varchar(32)
        , pAuthenticationStringLower varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
	authentication_id varchar(32)
	, authentication_string varchar(32)
	, authentication_string_lower varchar(32)
	, hash varchar(60)
	, salt varchar(16)
	, last_login timestamp without time zone
	, last_logout timestamp without time zone
	, last_change_password timestamp without time zone
	, request_authentication_start timestamp without time zone
	, request_authentication_end timestamp without time zone
	, authorization_level int
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
    FROM authentication a WHERE (
      ((pAuthenticationId IS NULL) OR (a.authentication_id = pAuthenticationId)) AND
      ((pAuthenticationStringLower IS NULL) OR (a.authentication_string_lower = pAuthenticationStringLower))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE authentication_init AS
      SELECT
        a.authentication_id
        , a.authentication_string
        , a.authentication_string_lower
        , a.hash
        , a.salt
        , a.last_login
        , a.last_logout
        , a.last_change_password
        , a.request_authentication_start
        , a.request_authentication_end
        , a.authorization_level
        , a.create_date
        , a.last_update
      FROM authentication a WHERE (
        ((pAuthenticationId IS NULL) OR (a.authentication_id = pAuthenticationId)) AND
        ((pAuthenticationStringLower IS NULL) OR (a.authentication_string_lower = pAuthenticationStringLower))
        )
      ORDER BY a.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM authentication_init;

END;
$BODY$
LANGUAGE plpgsql;