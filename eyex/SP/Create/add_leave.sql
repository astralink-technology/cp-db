-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_leave' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_leave(
    pLeaveId varchar(32)
  , pType CHAR(1)
  , pCreateDate timestamp without time zone
  , pLeaveStart timestamp without time zone
  , pLeaveEnd timestamp without time zone
  , pLeaveCount DECIMAL
  , pNotes TEXT
  , pOwnerId varchar(32)
)
  RETURNS varchar(32) AS
  $BODY$
BEGIN
    INSERT INTO leave (
        leave_id
        , type
        , create_date
        , leave_start
        , leave_end
        , leave_count
        , notes
        , owner_id
    ) VALUES(
        pLeaveId
        , pType
        , pCreateDate
        , pLeaveStart
        , pLeaveEnd
        , pLeaveCount
        , pNotes
        , pOwnerId
    );
    RETURN pLeaveId;
END;
$BODY$
LANGUAGE plpgsql;