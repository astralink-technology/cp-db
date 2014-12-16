-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_media' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_media(
    pMediaId varchar(32)
    , pTitle varchar(32)
    , pType char(1)
    , pFilename text
    , pMediaUrl text 
    , pStatus char(1)
    , pDescription text
    , pFileType varchar(16)
    , pImgUrl text
    , pImgUrl2 text
    , pImgUrl3 text
    , pImgUrl4 text
    , pOwnerId varchar(32)
    , pFileSize decimal
    , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oTitle varchar(32);
    oType char(1);
    oFilename text;
    oMediaUrl text; 
    oStatus char(1);
    oDescription text;
    oFileType varchar(16);
    oImgUrl text;
    oImgUrl2 text;
    oImgUrl3 text;
    oImgUrl4 text;
    oOwnerId varchar(32);
    oFileSize decimal;
    oLastUpdate timestamp without time zone;

    nTitle varchar(32);
    nType char(1);
    nFilename text;
    nMediaUrl text;
    nStatus char(1);
    nDescription text;
    nFileType varchar(16);
    nImgUrl text;
    nImgUrl2 text;
    nImgUrl3 text;
    nImgUrl4 text;
    nOwnerId varchar(32);
    nFileSize decimal;
    nLastUpdate timestamp without time zone;
BEGIN
    -- ID is needed if not return
    IF pMediaId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            m.title
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
            , m.owner_id
            , m.file_size
            , m.last_update
        INTO STRICT
            oTitle
            , oType
            , oFilename
            , oMediaUrl
            , oStatus
            , oDescription
            , oFileType
            , oImgUrl
            , oImgUrl2
            , oImgUrl3
            , oImgUrl4
            , oOwnerId
            , oFileSize
            , oLastUpdate
        FROM media m WHERE
            m.media_id = pMediaId;

        -- Start the updating process
        IF pTitle IS NULL THEN 
            nTitle := oTitle;
        ELSEIF pTitle = '' THEN  
            nTitle := NULL;
        ELSE
            nTitle := pTitle;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pType = '' THEN  
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pFilename IS NULL THEN 
            nFilename := oFilename;
        ELSEIF pFilename = '' THEN  
            nFilename := NULL;
        ELSE
            nFilename := pFilename;
        END IF;

        IF pMediaUrl IS NULL THEN 
            nMediaUrl := oMediaUrl;
        ELSEIF pMediaUrl = '' THEN  
            nMediaUrl := NULL;
        ELSE
            nMediaUrl := pMediaUrl;
        END IF;

        IF pStatus IS NULL THEN 
            nStatus := oStatus;
        ELSEIF pStatus = '' THEN  
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;

        IF pDescription IS NULL THEN
            nDescription := oDescription;
        ELSEIF pDescription = '' THEN
            nDescription := NULL;
        ELSE
            nDescription := pDescription;
        END IF;

        IF pFileType IS NULL THEN
            nFileType := oFileType;
        ELSEIF pFileType = '' THEN
            nFileType := NULL;
        ELSE
            nFileType := pFileType;
        END IF;

        IF pImgUrl IS NULL THEN
            nImgUrl := oImgUrl;
        ELSEIF pImgUrl = '' THEN
            nImgUrl := NULL;
        ELSE
            nImgUrl := pImgUrl;
        END IF;

        IF pImgUrl2 IS NULL THEN
            nImgUrl2 := oImgUrl2;
        ELSEIF pImgUrl2 = '' THEN
            nImgUrl2 := NULL;
        ELSE
            nImgUrl2 := pImgUrl2;
        END IF;

        IF pImgUrl3 IS NULL THEN
            nImgUrl3 := oImgUrl3;
        ELSEIF pImgUrl3 = '' THEN
            nImgUrl3 := NULL;
        ELSE
            nImgUrl3 := pImgUrl3;
        END IF;

        IF pImgUrl4 IS NULL THEN
            nImgUrl4 := oImgUrl4;
        ELSEIF pImgUrl4 = '' THEN
            nImgUrl4 := NULL;
        ELSE
            nImgUrl4 := pImgUrl4;
        END IF;

        IF pOwnerId IS NULL THEN 
            nOwnerId := oOwnerId;
        ELSEIF pOwnerId = '' THEN  
            nOwnerId := NULL;
        ELSE
            nOwnerId := pOwnerId;
        END IF;

        IF pFileSize IS NULL THEN 
            nFileSize := oFileSize;
        ELSEIF pFileSize = '' THEN  
            nFileSize := NULL;
        ELSE
            nFileSize := pFileSize;
        END IF;

        IF pLastUpdate IS NULL THEN
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            media
        SET 
            title = nTitle
            , type = nType
            , file_name = nFileName
            , media_url = nMediaUrl
            , status = nStatus
            , description = nDescription
            , file_type = nFileType
            , img_url = nImgUrl
            , img_url2 = nImgUrl2
            , img_url3 = nImgUrl3
            , img_url4 = nImgUrl4
            , owner_id = nOwnerId
            , file_size = nFileSize
            , last_update = nLastUpdate
        WHERE
            media_id = pMediaId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
