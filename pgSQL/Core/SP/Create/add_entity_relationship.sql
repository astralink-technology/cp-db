-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_entity_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_entity_relationship(
	pEntityRelationshipId varchar(32), 
	pEntityId varchar(32), 
	pRelatedId varchar(32), 
	pStatus char(1),
	pCreateDate timestamp without time zone,
	pType char(1)`
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO entity_relationship (
      entity_relationship_id
      , entity_id
      , related_id
      , status
      , create_date
      , type
    ) VALUES(
      pEntityRelationshipId
      , pEntityId
      , pRelatedId
      , pStatus
      , pCreateDate
      , pType
    );
    RETURN pEntityRelationshipId;
END;
$BODY$
LANGUAGE plpgsql;
