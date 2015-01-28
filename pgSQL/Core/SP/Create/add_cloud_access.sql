-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_cloud_access' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_cloud_access(
      pCloudAccessId varchar(32)
      , pSecret varchar(32)
      , pExtraData TEXT
      , pExtraDateTime timestamp without time zone
      , pCreateDate timestamp without time zone
      , pLastUpdate timestamp without time zone
      , pOwnerId varchar(32)
      , pType varchar(4)
      , pToken text
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
      INSERT INTO cloud_access (
        cloud_access_id
        , secret
        , extra_data
        , extra_date_time
        , create_date
        , last_update
        , owner_id
        , type
        , token
    ) VALUES(
        pCloudAccessId
        , pSecret
        , pExtraData
        , pExtraDateTime
        , pCreateDate
        , pLastUpdate
        , pOwnerId
        , pType
        , pToken
    );
    RETURN pCloudAccessId;
END;
$BODY$
LANGUAGE plpgsql;