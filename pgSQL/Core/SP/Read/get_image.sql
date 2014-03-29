-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS get_image(
	pImageId varchar(32)
	, pTitle varchar(32)
	, pType char(1)
  , pFilename text
	, pImageUrl text
	, pStatus char(1)
	, pFileType varchar(16)
	, pOwnerId varchar(32)
	, pPageSize integer
	, pSkipSize integer
);
-- Start function
CREATE FUNCTION get_image(
	pImageId varchar(32)
	, pTitle varchar(32)
	, pType char(1)
  , pFilename text
	, pImageUrl text
	, pStatus char(1)
	, pFileType varchar(16)
	, pOwnerId varchar(32)
	, pPageSize integer
	, pSkipSize integer
)
RETURNS TABLE(
	image_id varchar(32)
	, title varchar(32)
	, type char(1)
  , file_name text
	, img_url text 
	, status char(1)
	, description text
	, file_type varchar(16)
	, create_date timestamp without time zone
	, owner_id varchar(32)
	, file_size decimal
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
    FROM image im WHERE (
      ((pImageId IS NULL) OR (im.image_id = pImageId)) AND
      ((pTitle IS NULL) OR (im.title = pTitle)) AND
      ((pType IS NULL) OR (im.type = pType))AND
      ((pFilename IS NULL) OR (im.file_name = pFilename))AND
      ((pImageUrl IS NULL) OR (im.img_url = pImageUrl))AND
      ((pStatus IS NULL) OR (im.status = pStatus))AND
      ((pFileType IS NULL) OR (im.file_type = pFileType))AND
      ((pOwnerId IS NULL) OR (im.owner_id = pOwnerId))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE image_init AS
      SELECT
      im.image_id
      , im.title
      , im.type
      , im.file_name
      , im.img_url
      , im.status
      , im.description
      , im.file_type
      , im.create_date
      , im.owner_id
      , im.file_size
      FROM image im WHERE (
        ((pImageId IS NULL) OR (im.image_id = pImageId)) AND
        ((pTitle IS NULL) OR (im.title = pTitle)) AND
        ((pType IS NULL) OR (im.type = pType))AND
        ((pFilename IS NULL) OR (im.file_name = pFilename))AND
        ((pImageUrl IS NULL) OR (im.img_url = pImageUrl))AND
        ((pStatus IS NULL) OR (im.status = pStatus))AND
        ((pFileType IS NULL) OR (im.file_type = pFileType))AND
        ((pOwnerId IS NULL) OR (im.owner_id = pOwnerId))
    )
    ORDER BY im.create_date
    LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM image_init;
END;
$BODY$
LANGUAGE plpgsql;
