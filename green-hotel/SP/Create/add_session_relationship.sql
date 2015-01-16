-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_session_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_session_relationship(
  pSessionRelationshipId VARCHAR(32)
  , pSessionId VARCHAR(32)
  , pOwnerId VARCHAR(32)
  , pType VARCHAR(4)
  , pStatus CHAR(1)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO session_relationship (
        session_relationship_id
        , session_id
        , owner_id
        , type
        , status
    ) VALUES(
        pSessionRelationshipId
        , pSessionId
        , pOwnerId
        , pType
        , pStatus
    );
    RETURN pSessionRelationshipId;
END;
$BODY$
LANGUAGE plpgsql;