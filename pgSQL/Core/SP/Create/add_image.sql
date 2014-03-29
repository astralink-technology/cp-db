-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_image(
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
);
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
