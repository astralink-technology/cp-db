-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_hotel_devices' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_hotel_devices(
        pDeviceId varchar(32)
        , pHotelId varchar(32)
        , pRoomId varchar(32)
        , pRoomNumber varchar(64)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
      device_id varchar(32)
      , name varchar(32)
      , code varchar(32)
      , status char(1)
      , type varchar(4)
      , type2 varchar(4)
      , description text
      , create_date timestamp without time zone
      , last_update timestamp without time zone
      , deployment_date date
      , owner_id varchar(32)
      , room_id varchar(32)
      , room_number varchar(64)
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
    FROM device d INNER JOIN device_value dv ON d.device_id = dv.device_id
    INNER JOIN device_relationship dr ON d.device_id = dr.device_id
    LEFT JOIN room r ON r.room_id = d.owner_id;

    -- create a temp table to get the data
    CREATE TEMP TABLE device_init AS
      SELECT
          d.device_id
          , d.name
          , d.code
          , d.status
          , d.type
          , d.type2
          , d.description
          , d.create_date
          , d.last_update
          , d.deployment_date
          , dr.owner_id
          , r.room_id
          , r.room_number
          FROM device d INNER JOIN device_value dv ON d.device_id = dv.device_id
          INNER JOIN device_relationship dr ON d.device_id = dr.device_id
          LEFT JOIN room r ON r.room_id = d.owner_id WHERE (
           ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId)) AND
           ((pHotelId IS NULL) OR (dr.owner_id = pHotelId)) AND
           ((pRoomNumber IS NULL) OR (r.room_number = pRoomNumber)) AND
           ((pRoomId IS NULL) OR (r.room_id = pRoomId))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM device_init;
END;
$BODY$
LANGUAGE plpgsql;