-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_enterprise_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_enterprise_relationship(
      pEnterpriseRelationshipId varchar(32)
      , pEnterpriseId varchar(32)
      , pOwnerId varchar(32)
      , pStatus char(1)
      , pType varchar(4)
      , pCreateDate timestamp without time zone
      , pLastUpdate timestamp without time zone
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO enterprise_relationship (
        enterprise_relationship_id
        , enterprise_id
        , owner_id
        , status
        , type
        , create_date
        , last_update
    ) VALUES(
        pEnterpriseRelationshipId
        , pEnterpriseId
        , pOwnerId
        , pStatus
        , pType
        , pCreateDate
        , pLastUpdate
    );
    RETURN pEnterpriseRelationshipId;
END;
$BODY$
LANGUAGE plpgsql;