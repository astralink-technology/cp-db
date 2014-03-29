-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS add_media(
	pMediaId varchar(32)
	, pTitle varchar(32)
	, pType char(1)
  , pFilename text
	, pMediaUrl text 
	, pStatus char(1)
	, pCreateDate timestamp without time zone
	, pDescription text
	, pFileType varchar(16)
	, pImgUrl text
	, pImgUrl2 text
	, pImgUrl3 text
	, pImgUrl4 text
	, pDeviceId varchar(32)
	, pEntityId varchar(32)
	, pFileSize decimal
);
-- Start function
CREATE FUNCTION add_media(
	pMediaId varchar(32)
	, pTitle varchar(32)
	, pType char(1)
  , pFilename text
	, pMediaUrl text 
	, pStatus char(1)
	, pCreateDate timestamp without time zone
	, pDescription text
	, pFileType varchar(16)
	, pImgUrl text
	, pImgUrl2 text
	, pImgUrl3 text
	, pImgUrl4 text
	, pOwnerId varchar(32)
	, pFileSize decimal
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO media(
	media_id
	, title 
	, type
  , file_name
	, media_url
	, status 
	, create_date
	, description
	, file_type
	, img_url
	, img_url2
	, img_url3
	, img_url4
	, owner_id
	, file_size
    ) VALUES(
	pMediaId
	, pTitle
	, pType
  , pFilename
	, pMediaUrl
	, pStatus
	, pCreateDate
	, pDescription
	, pFileType
	, pImgUrl
	, pImgUrl2
	, pImgUrl3
	, pImgUrl4
	, pOwnerId
	, pFileSize
    );
    RETURN pMediaId;
END;
$BODY$
LANGUAGE plpgsql;
