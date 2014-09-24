-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_extension' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_extension(
        pExtensionId varchar(32)
        , pExtension integer
        , pExtensionPassword varchar(128)
        , pLastUpdate timestamp without time zone
        , pCreateDate timestamp without time zone
        , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO extension (
        extension_id
        , extension
        , extension_password
        , last_udpate
        , create_date
        , owner_id
    ) VALUES(
        pExtensionId
        , pExtension
        , pExtensionPassword
        , pLastUpdate
        , pCreateDate
        , pOwnerId
    );
    RETURN pExtensionId;
END;
$BODY$
LANGUAGE plpgsql;