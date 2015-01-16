-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_unconnected_room' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_unconnected_room(
        pDeviceId varchar(32)
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
    sRoomId varchar(32);
    sRoomNumber varchar(64);
    sOwnerId varchar(32);

    totalRows integer;
BEGIN

    CREATE TEMP TABLE self_room_init(
        room_id varchar(32)
        , room_number varchar(64)
        , owner_id varchar(32)
    );

    -- create a temp table to get the data
    IF pDeviceId IS NULL THEN

      CREATE TEMP TABLE unconnected_room_init AS
        SELECT
            r.room_id
            , r.room_number
            , r.owner_id
            FROM room r LEFT JOIN device d ON r.room_id = d.owner_id WHERE
            d.owner_id IS NULL AND
           ((pOwnerId IS NULL) OR (r.owner_id = pOwnerId));
    ELSE
      CREATE TEMP TABLE unconnected_room_init AS
        SELECT
            r.room_id
            , r.room_number
            , r.owner_id
            FROM room r LEFT JOIN device d ON r.room_id = d.owner_id WHERE
            d.owner_id IS NULL AND
           ((pOwnerId IS NULL) OR (r.owner_id = pOwnerId))

        UNION

        SELECT
            r.room_id
            , r.room_number
            , r.owner_id
        FROM room r LEFT JOIN device d ON r.room_id = d.owner_id WHERE
            d.device_id = pDeviceId;
    END IF;


    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM unconnected_room_init;

    RETURN QUERY
      SELECT
        *
        , totalRows
      FROM unconnected_room_init
      LIMIT pPageSize OFFSET pSkipSize;

END;
$BODY$
LANGUAGE plpgsql;