-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_session_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_session_relationship(
      pSessionRelationshipId VARCHAR(32)
      , pSessionId VARCHAR(32)
      , pOwnerId VARCHAR(32)
      , pType VARCHAR(4)
      , pStatus CHAR(1)
      , pPageSize integer
      , pSkipSize integer
    )
RETURNS TABLE(
	session_relationship_id varchar(32)
	, session_id varchar(32)
	, owner_id varchar(32)
	, totalRows integer
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
    FROM session_relationship;

    -- create a temp table to get the data
    CREATE TEMP TABLE session_relationship_init AS
      SELECT
          sr.session_relationship_id
          , sr.session_id
          , sr.owner_id
          , sr.type
          , sr.status
          FROM session_relationship sr WHERE (
           ((pSessionRelationshipId IS NULL) OR (sr.session_relationship_id = pSessionRelationshipId)) AND
           ((pSessionId IS NULL) OR (sr.session_id = pSessionId)) AND
           ((pType IS NULL) OR (sr.type = pType)) AND
           ((pStatus IS NULL) OR (sr.status = pStatus)) AND
           ((pOwnerId IS NULL) OR (sr.owner_id = pOwnerId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM session_relationship_init;
END;
$BODY$
LANGUAGE plpgsql;