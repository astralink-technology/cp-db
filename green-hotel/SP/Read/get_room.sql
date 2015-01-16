-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_room' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_room(
        pRoomId varchar(32)
        , pRoomNumber varchar(64)
        , pOwnerId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
    room_id varchar(32)
    , room_number varchar(64)
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
    FROM room;

    -- create a temp table to get the data
    CREATE TEMP TABLE room_init AS
      SELECT
          r.room_id
          , r.room_number
          , r.owner_id
          FROM room r WHERE (
           ((pRoomId IS NULL) OR (r.room_id = pRoomId)) AND
           ((pRoomNumber IS NULL) OR (r.room_number = pRoomNumber)) AND
           ((pOwnerId IS NULL) OR (r.owner_id = pOwnerId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM room_init;
END;
$BODY$
LANGUAGE plpgsql;