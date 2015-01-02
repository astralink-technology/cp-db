-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_announcement' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_announcement(
    pAnnouncementId varchar(32)
    , pDescription text
    , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oDescription text;
    oLastUpdate timestamp without time zone;

    nDescription text;
    nLastUpdate timestamp without time zone;
BEGIN
    -- ID is needed if not return
    IF pAnnouncementId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            m.description
            , m.last_update
        INTO STRICT
            oDescription
            , oLastUpdate
        FROM media m WHERE
            m.media_id = pAnnouncementId;

        -- Start the updating process
        IF pDescription IS NULL THEN
            nDescription := oDescription;
        ELSE
            nDescription := pDescription;
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
            description = nDescription
            , last_update = nLastUpdate
        WHERE
            media_id = pAnnouncementId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
