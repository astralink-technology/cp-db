-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_sip' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_sip(
        pSipId varchar(32)
        , pSipHost varchar(256)
        , pSipPassword varchar(128)
        , pLastUpdate timestamp without time zone
        , pCreateDate timestamp without time zone
        , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO sip (
        sip_id
        , sip_host
        , sip_password
        , last_update
        , create_date
        , owner_id
    ) VALUES(
        pSipId
        , pSipHost
        , pSipPassword
        , pLastUpdate
        , pCreateDate
        , pOwnerId
    );
    RETURN pSipId;
END;
$BODY$
LANGUAGE plpgsql;