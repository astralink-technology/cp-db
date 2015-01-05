-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_door_relationship' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_door_relationship(
        pDoorRelationshipid varchar(32)
        , pDoorId varchar(32)
        , pDeviceId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
  door_relationship_id varchar(32)
  , door_id varchar(32)
  , device_id varchar(32)
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
    FROM door_relationship;

    -- create a temp table to get the data
    CREATE TEMP TABLE door_relationship_init AS
      SELECT
          dr.door_relationship_id
          , dr.door_id
          , dr.device_id
          FROM door_relationship dd WHERE (
           ((pDoorRelationshipId IS NULL) OR (d.door_relationship_id = pDoorRelationshipId)) AND
           ((pDeviceId IS NULL) OR (d.device_id = pDeviceId))
           ((pDoorId IS NULL) OR (d.door_id = pDoorId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM door_relationship_init;
END;
$BODY$
LANGUAGE plpgsql;