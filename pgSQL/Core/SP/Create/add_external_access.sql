  -- Drop function
  DO $$
  DECLARE fname text;
  BEGIN
  FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_external_access' LOOP
    EXECUTE 'DROP FUNCTION ' || fname;
  END loop;
  RAISE INFO 'FUNCTION % DROPPED', fname;
  END$$;
  -- Start function
  CREATE FUNCTION add_external_access(
      pExternalAccessId varchar(32)
      , pUniqueIdentifier varchar(32)
      , pOwnerId varchar(32)
      , pEnterpriseId varchar(32)
  )
  RETURNS varchar(32) AS
  $BODY$
  BEGIN
      INSERT INTO external_access (
          external_access_id
          , unique_identifier
          , owner_id
          , enterprise_id
      ) VALUES(
          pExternalAccessId
          , pUniqueIdentifier
          , pOwnerId
          , pEnterpriseId
      );
      RETURN pExternalAccessId;
  END;
  $BODY$
  LANGUAGE plpgsql;
