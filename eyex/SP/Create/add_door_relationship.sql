-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_door_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_door_relationship(
      pDoorRelationshipId varchar(32)
      , pDoorId varchar(32)
      , pDeviceId varchar(32)
)
RETURNS varchar(32) AS
$BODY$
BEGIN
    INSERT INTO door_relationship (
        door_relationship_id
        , door_id
        , device_id
    ) VALUES(
        pDoorRelationshipId
        , pDoorId
        , pDeviceId
    );
    RETURN pDoorRelationshipId;
END;
$BODY$
LANGUAGE plpgsql;