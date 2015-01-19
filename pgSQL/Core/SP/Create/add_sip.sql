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
    , pUsername varchar(128)
    , pPassword text
    , pCreateDate timestamp without time zone
    , pLastUpdate timestamp without time zone
    , pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO sip(
        sip
        , username
        , password
        , create_date
        , last_update
        , owner_id
    ) VALUES(
        pSipId
        , pUsername
        , pPassword
        , pCreateDate
        , pLastUpdate
        , pOwnerId
    );
    RETURN pSipId;
END;
$BODY$
LANGUAGE plpgsql;