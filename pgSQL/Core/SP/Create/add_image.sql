-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_image' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_image(
	pImageId varchar(32)
	, pTitle varchar(32)
	, pType char(1)
  , pFilename text
	, pImageUrl text 
	, pStatus char(1)
	, pCreateDate timestamp without time zone
	, pDescription text
	, pFileType varchar(16)
	, pOwnerId varchar(32)
	, pFileSize decimal
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO image(
	image_id
	, title 
	, type
  , file_name
	, img_url
	, status 
	, create_date
	, description
	, file_type
	, owner_id
	, file_size
    ) VALUES(
	pImageId
	, pTitle
	, pType
  , pFilename
	, pImageUrl
	, pStatus
	, pCreateDate
	, pDescription
	, pFileType
	, pOwnerId
	, pFileSize
    );
    RETURN pImageId;
END;
$BODY$
LANGUAGE plpgsql;
