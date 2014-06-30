-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_message_read' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_message_read(
    pMessageReadId varchar(32)
    , pMessageId varchar(32)
    , pReaderId varchar(32)
    , pStatus char(1)
    , pCreateDate timestamp without time zone
)
RETURNS varchar(32) AS
$BODY$
BEGIN
    INSERT INTO message (
        message_read_id
        , message_id
        , reader_id
        , status
        , create_date
    ) VALUES(
        pMessageReadId
        , pMessageId
        , pReaderId
        , pCreateDate
        , pStatus
    );
    RETURN pMessageId;
END;
$BODY$
LANGUAGE plpgsql;
