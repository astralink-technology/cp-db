-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_announcement' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_announcement(
	pMediaId varchar(32)
	, pTitle varchar(32)
  , pFilename text
	, pMediaUrl text
	, pStatus char(1)
	, pFileType varchar(16)
	, pOwnerId varchar(32)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	media_id varchar(32)
	, title varchar(32)
	, type CHAR(1)
  , file_name text
	, media_url text 
	, status char(1)
	, description text
	, file_type varchar(16)
	, image_url text
	, image_url2 text
	, image_url3 text
	, image_url4 text
	, create_date timestamp without time zone
	, owner_id varchar(32)
	, file_size decimal
	, last_update timestamp without time zone
	, total_rows integer
) AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM media m WHERE m.type = 'A';

    -- create a temp table to get the data
    CREATE TEMP TABLE media_init AS
    SELECT
      m.media_id
      , m.title
      , m.type
      , m.file_name
      , m.media_url
      , m.status
      , m.description
      , m.file_type
      , m.img_url
      , m.img_url2
      , m.img_url3
      , m.img_url4
      , m.create_date
      , m.owner_id
      , m.file_size
      , m.last_update
    FROM media m WHERE (
      (m.type = 'A') AND
      ((pMediaId IS NULL) OR (m.media_id = pMediaId)) AND
      ((pTitle IS NULL) OR (m.title = pTitle)) AND
      ((pFilename IS NULL) OR (m.file_name = pFilename))AND
      ((pMediaUrl IS NULL) OR (m.media_url = pMediaUrl))AND
      ((pStatus IS NULL) OR (m.status = pStatus))AND
      ((pFileType IS NULL) OR (m.file_type = pFileType))AND
      ((pOwnerId IS NULL) OR (m.owner_id = pOwnerId))
	)
  ORDER BY m.create_date
  LIMIT pPageSize OFFSET pSkipSize;

  RETURN QUERY
    SELECT
      *
      , totalRows
    FROM media_init;

END;
$BODY$
LANGUAGE plpgsql;
