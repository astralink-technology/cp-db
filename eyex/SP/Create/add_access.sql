-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_access' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_access(
        pAccessId varchar(32)
        , pPin varchar(8)
        , pCardId text
        , pExtensionId varchar(32)
        , pCreateDate timestamp without time zone
        , pLastUpdate timestamp without time zone
        , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO access (
        access_id
        , pin
        , card_id
        , extension_id
        , create_date
        , last_update
        , owner_id
    ) VALUES(
        pAccessId
        , pPin
        , pCardId
        , pExtensionId
        , pCreateDate
        , pLastUpdate
        , pOwnerId
    );
    RETURN pAccessId;
END;
$BODY$
LANGUAGE plpgsql;