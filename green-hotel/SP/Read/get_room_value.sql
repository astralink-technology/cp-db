-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_room_value' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_room_value(
        pRoomValueId varchar(32)
        , pName varchar(128)
        , pType varchar(4)
        , pStatus char(1)
        , pValue varchar(64)
        , pIntValue decimal
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
    room_value_id varchar(32)
    , name varchar(128)
    , type varchar(4)
    , status char(1)
    , value varchar(64)
    , int_value decimal
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
    FROM room_value;

    -- create a temp table to get the data
    CREATE TEMP TABLE room_value_init AS
      SELECT
          rv.room_value_id
          , rv.name
          , rv.type
          , rv.status
          , rv.value
          , rv.int_value
      FROM room_value rv WHERE (
           ((pRoomValueId IS NULL) OR (rv.room_value_id = pRoomValueId)) AND
           ((pName IS NULL) OR (rv.name = pName)) AND
           ((pType IS NULL) OR (rv.type = pType)) AND
           ((pStatus IS NULL) OR (rv.status = pStatus)) AND
           ((pValue IS NULL) OR (rv.value = pValue)) AND
           ((pIntValue IS NULL) OR (rv.int_value = pIntValue))
          )
          LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM room_value_init;
END;
$BODY$
LANGUAGE plpgsql;