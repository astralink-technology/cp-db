-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_device_relationship_media' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_device_relationship_media(
  pMediaId varchar(32)
  , pType char(1)
  , pStatus char(1)
  , pOwnerId varchar(32)
  , pDeviceId varchar(32)
  , pDeviceRelationshipId varchar(32)
  , pPageSize integer
  , pSkipSize integer
)
RETURNS TABLE(
    media_id varchar(32)
    , title varchar(32)
    , type char(1)
    , file_name text
    , media_url text
    , status char(1)
    , create_date timestamp without time zone
    , description text
    , img_url text
    , img_url2 text
    , img_url3 text
    , img_url4 text
    , file_size decimal
    , file_type varchar(16)
    , owner_id varchar(32)
    , device_id varchar(32)
    , device_relationship_id varchar(32)
    , device_relationship_create_date timestamp without time zone
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
    FROM media m INNER JOIN
    device_relationship dr ON dr.device_relationship_id = m.owner_id WHERE (
      ((pMediaId IS NULL) OR (m.media_id = pMediaId)) AND
      ((pType IS NULL) OR (m.type = pType))AND
      ((pStatus IS NULL) OR (m.status = pStatus))AND
      ((pOwnerId IS NULL) OR (dr.owner_id = pOwnerId))AND
      ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId))AND
      ((pDeviceRelationshipId IS NULL) OR (dr.device_relationship_id = pDeviceRelationshipId))
    );

    -- create a temp table to get the data
    CREATE TEMP TABLE device_relationship_media_init AS
      SELECT
        m.media_id
        , m.title
        , m.type
        , m.file_name
        , m.media_url
        , m.status
        , m.create_date
        , m.description
        , m.img_url
        , m.img_url2
        , m.img_url3
        , m.img_url4
        , m.file_size
        , m.file_type
        , dr.owner_id
        , dr.device_id
        , dr.device_relationship_id
        , dr.create_date as device_relationship_create_date
      FROM media m INNER JOIN
      device_relationship dr ON dr.device_relationship_id = m.owner_id WHERE (
        ((pMediaId IS NULL) OR (m.media_id = pMediaId)) AND
        ((pType IS NULL) OR (m.type = pType))AND
        ((pStatus IS NULL) OR (m.status = pStatus))AND
        ((pOwnerId IS NULL) OR (dr.owner_id = pOwnerId))AND
        ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId))AND
        ((pDeviceRelationshipId IS NULL) OR (dr.device_relationship_id = pDeviceRelationshipId))
      )
      ORDER BY m.create_date
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY
    SELECT
      *
      , totalRows
    FROM device_relationship_media_init;
END;
$BODY$
LANGUAGE plpgsql;
