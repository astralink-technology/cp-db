-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_door' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_door(
        pDoorId varchar(32)
        , pDoorName varchar(64)
        , pDoorNode integer
        , pOwnerId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
  door_id varchar(32)
  , door_name varchar(64)
  , door_node integer
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
    FROM door;

    -- create a temp table to get the data
    CREATE TEMP TABLE door_init AS
      SELECT
          d.door_id
          , d.door_name
          , d.door_node
          , d.owner_id
          , d.last_update
          FROM door d WHERE (
           ((pDoorId IS NULL) OR (d.door_id = pDoorId)) AND
           ((pDoorName IS NULL) OR (d.door_name = pDoorName)) AND
           ((pDoorNode IS NULL) OR (d.door_node = pDoorNode)) AND
           ((pOwnerId IS NULL) OR (f.owner_id = pOwnerId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM door_init;
END;
$BODY$
LANGUAGE plpgsql;