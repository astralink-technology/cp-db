-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_message_read' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_message_read(
    pMessageReadId varchar(32)
    , pMessageId varchar(32)
    , pReaderId varchar(32)
    , pStatus char(1)
    , pPageSize integer
    , pSkipSize integer
)
RETURNS TABLE(
	message_read_id varchar(32)
	, message_id varchar(32)
	, reader_id varchar(32)
	, status char(1)
	, create_date timestamp without time zone
	, total_rows integer
) AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO
      totalRows
    FROM message_read mr WHERE (
      ((pMessageReadId IS NULL) OR (mr.message_read_id = pMessageReadId)) AND
      ((pMessageId IS NULL) OR (mr.message_id = pMessageId)) AND
      ((pReaderId IS NULL) OR (mr.reader_id = pReaderId)) AND
      ((pStatus IS NULL) OR (mr.status = pStatus))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE message_read_init AS
      SELECT
        mr.message_read_id
        , mr.message_id
        , mr.reader_id
        , mr.status
        , mr.create_date
      FROM message_read mr WHERE (
          ((pMessageReadId IS NULL) OR (mr.message_read_id = pMessageReadId)) AND
          ((pMessageId IS NULL) OR (mr.message_id = pMessageId)) AND
          ((pReaderId IS NULL) OR (mr.reader_id = pReaderId)) AND
          ((pStatus IS NULL) OR (mr.status = pStatus))
        )
      ORDER BY mr.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM message_read_init;
END;
$BODY$
LANGUAGE plpgsql;