-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_image' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_image(
    pImageId varchar(32)
    , pTitle varchar(32)
    , pType char(1)
    , pFilename text
    , pImageUrl text 
    , pStatus char(1)
    , pDescription text
    , pFileType varchar(16)
    , pOwnerId varchar(32)
    , pFileSize decimal
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oTitle varchar(32);
    oType char(1);
    oFilename text;
    oImageUrl text; 
    oStatus char(1);
    oDescription text;
    oFileType varchar(16);
    oOwnerId varchar(32);
    oFileSize decimal;

    nTitle varchar(32);
    nType char(1);
    nFilename text;
    nImageUrl text;
    nStatus char(1);
    nDescription text;
    nFileType varchar(16);
    nOwnerId varchar(32);
    nFileSize decimal;
BEGIN
    -- ID is needed if not return
    IF pImageId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            im.title
            , im.type 
            , im.file_name
            , im.img_url
            , im.status
            , im.description
            , im.file_type
            , im.owner_id
            , im.file_size
        INTO STRICT
            oTitle
            , oType
            , oFilename
            , oImageUrl
            , oStatus
	    , oDescription
	    , oFileType
            , oOwnerId
            , oFileSize
        FROM image im WHERE 
            im.image_id = pImageId;

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

        IF pImageUrl IS NULL THEN 
            nImageUrl := oImageUrl;
        ELSEIF pImageUrl = '' THEN  
            nImageUrl := NULL;
        ELSE
            nImageUrl := pImageUrl;
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

        -- start the update
        UPDATE 
            image
        SET 
            title = pTitle
            , type = pType
            , file_name = pFileName
            , img_url = pImageUrl
            , status = pStatus
            , description = pDescription
            , file_type = pFileType
            , owner_id = pOwnerId
            , file_size = pFileSize
        WHERE 
            image_id = pImageId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
