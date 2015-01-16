-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_room_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_room_details(
        pRoomId varchar(32)
        , pRoomNumber varchar(64)
        , pDeviceId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
    room_id varchar(32)
    , room_number varchar(64)
    , owner_id varchar(32)
    , session_id varchar(32)
    , start_date timestamp without time zone
    , end_date timestamp without time zone
    , create_date timestamp without time zone
    , type varchar(4)
    , status char(1)
    , value varchar(32)
    , value2 varchar(32)
    , value3 varchar(32)
    , int_value decimal
    , int_value2 decimal
    , int_value3 decimal
    , device_id varchar(32)
    , booking_id varchar(32)
    , booking_start timestamp without time zone
    , booking_end timestamp without time zone
    , guest_id varchar(32)
    , first_name varchar(128)
    , last_name varchar(128)
	  , name varchar(256)
    , totalRows integer
  )
AS
$BODY$
DECLARE
    totalRows integer;
BEGIN

    -- create a temp table with all the available sessions
    CREATE TEMP TABLE current_session_init AS
      SELECT
        r.room_id
        , s.session_id
        , s.start_date
        , s.end_date
        , s.create_date
        , s.type
        , s.status
        , s.value
        , s.value2
        , s.value3
        , s.int_value
        , s.int_value2
        , s.int_value3
        , s.object_id
        , ss.session_id as booking_id
        , ss.start_date as booking_start
        , ss.end_date as booking_end
        , e.entity_id as guest_id
        , e.first_name
        , e.last_name
        , e.name
      FROM room r LEFT JOIN session s ON s.owner_id = r.room_id
      LEFT JOIN session ss ON s.object_id = ss.session_id
      LEFT JOIN session_relationship sr ON sr.session_id = s.object_id
      INNER JOIN entity e ON e.entity_id = sr.owner_id
      WHERE current_timestamp BETWEEN s.start_date AND s.end_date AND
      s.type = 'Q' AND (sr.type IS NULL OR sr.type = 'P');

    -- create a temp table to get the data
    CREATE TEMP TABLE room_init AS
      SELECT
          r.room_id
          , r.room_number
          , r.owner_id
          , d.device_id
          FROM room r LEFT JOIN device d ON d.owner_id = r.room_id WHERE (
           ((pRoomId IS NULL) OR (r.room_id = pRoomId)) AND
           ((pDeviceId IS NULL) OR (d.device_id = pDeviceId)) AND
           ((pRoomNumber IS NULL) OR (r.room_number = pRoomNumber))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM room_init ri LEFT JOIN current_session_init cs ON ri.room_id = cs.room_id;

    RETURN QUERY
      SELECT
        ri.room_id
        , ri.room_number
        , ri.owner_id
        , cs.session_id
        , cs.start_date
        , cs.end_date
        , cs.create_date
        , cs.type
        , cs.status
        , cs.value
        , cs.value2
        , cs.value3
        , cs.int_value
        , cs.int_value2
        , cs.int_value3
        , ri.device_id
        , cs.booking_id
        , cs.booking_start
        , cs.booking_end
        , cs.guest_id
        , cs.first_name
        , cs.last_name
        , cs.name
        , totalRows
      FROM room_init ri LEFT JOIN current_session_init cs ON ri.room_id = cs.room_id;
END;
$BODY$
LANGUAGE plpgsql;