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
    , pName varchar(64)
    , pType char(1)
    , pDateStart timestamp without time zone
    , pDateEnd timestamp without time zone
    , pCreateDate timestamp without time zone
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO leave (
        leave_id
        , name
        , type
        , date_start
        , date_end
        , create_date
        , last_update
        , owner_id
    ) VALUES(
        pLeaveId
        , pName
        , pType
        , pDateStart
        , pDateEnd
        , pCreateDate
        , pLastUpdate
        , pOwnerId
    );
    RETURN pLeaveId;
END;
$BODY$
LANGUAGE plpgsql;