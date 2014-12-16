-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_announcement' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_announcement(
	pAnnouncementId varchar(32)
	, pDescription text
	, pCreateDate timestamp without time zone
	, pOwnerId varchar(32)
	, pLastUpdate timestamp without time zone
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO media(
      media_id
      , title
      , type
      , create_date
      , description
      , owner_id
      , last_update
    ) VALUES(
      pAnnouncementId
      , 'Announcement'
      , 'A'
      , pCreateDate
      , pDescription
      , pOwnerId
      , pLastUpdate
    );
    RETURN pAnnouncementId;
END;
$BODY$
LANGUAGE plpgsql;