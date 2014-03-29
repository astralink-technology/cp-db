-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS get_entity(
        pEntityId varchar(32)
        , pAuthenticationId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    );
-- Start function
CREATE FUNCTION get_entity(
        pEntityId varchar(32)
        , pAuthenticationId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
    entity_id varchar(32)
    , first_name varchar(32)
    , last_name varchar(32)
    , nick_name varchar(32)
    , name varchar(64)
    , status char(1)
    , approved boolean
    , type char(1)
    , create_date timestamp without time zone
    , last_update timestamp without time zone
    , authentication_id varchar(32)
    , primary_email_id varchar(32)
    , primary_phone_id varchar(32)
    , total_rows integer
  )
AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM entity;

    -- create a temp table to get the data
    CREATE TEMP TABLE entity_init AS
      SELECT
        e.entity_id
        , e.first_name
        , e.last_name
        , e.nick_name
        , e.name
        , e.status
        , e.approved
        , e.type
        , e.create_date
        , e.last_update
        , e.authentication_id
        , e.primary_email_id
        , e.primary_phone_id
          FROM entity e WHERE (
          ((pEntityId IS NULL) OR (e.entity_id = pEntityId)) AND
          ((pAuthenticationId IS NULL) OR (e.authentication_id = pAuthenticationId))
        )
      ORDER BY e.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM entity_init;

END;
$BODY$
LANGUAGE plpgsql;