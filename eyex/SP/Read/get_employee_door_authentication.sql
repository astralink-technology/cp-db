  -- Drop function
  DO $$
  DECLARE fname text;
  BEGIN
  FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_employee_door_authentication' LOOP
    EXECUTE 'DROP FUNCTION ' || fname;
  END loop;
  RAISE INFO 'FUNCTION % DROPPED', fname;
  END$$;
  -- Start function
  CREATE FUNCTION get_employee_door_authentication(
        pDeviceId varchar(32)
        , pCompanyId varchar(32)
      )
  RETURNS TABLE(
      entity_id varchar(32)
      , first_name varchar(32)
      , last_name varchar(32)
      , name varchar(64)
      , authorize integer
      , totalRows integer
    )
  AS
  $BODY$
  DECLARE
      totalRows integer;
  BEGIN

    -- get all the employees of the company
    CREATE TEMP TABLE employees_init AS
      SELECT
        e.entity_id
        , e.name
        , e.first_name
        , e.last_name
        , e.authentication_id
      FROM entity_relationship er LEFT JOIN entity e ON er.related_id = e.entity_id WHERE
      er.entity_id = pCompanyId;

      -- count the total rows
      SELECT
        COUNT(*)
      INTO STRICT
        totalRows
      FROM (
            SELECT
                e.entity_id
                , e.name
                , e.first_name
                , e.last_name
                , 0 AS authorize
            FROM employees_init e LEFT JOIN authentication a ON a.authentication_id = e.authentication_id
            WHERE e.entity_id NOT IN (
              SELECT dr.owner_id FROM device_relationship dr WHERE
              ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId))
            ) AND a.authorization_level < 400

            UNION

            SELECT
                e.entity_id
                , e.name
                , e.first_name
                , e.last_name
                , 1 AS authorize
            FROM employees_init e LEFT JOIN authentication a ON a.authentication_id = e.authentication_id
            WHERE e.entity_id IN (
              SELECT dr.owner_id FROM device_relationship dr WHERE
              ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId))
            ) AND a.authorization_level < 400
        ) ea;


  -- create a temp table to get the data
      CREATE TEMP TABLE employee_door_auth_init AS
        SELECT * FROM (
            SELECT
                e.entity_id
                , e.name
                , e.first_name
                , e.last_name
                , 0 AS authorize
            FROM employees_init e LEFT JOIN authentication a ON a.authentication_id = e.authentication_id
            WHERE e.entity_id NOT IN (
              SELECT dr.owner_id FROM device_relationship dr WHERE
              ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId))
            ) AND a.authorization_level < 400

            UNION

            SELECT
                e.entity_id
                , e.name
                , e.first_name
                , e.last_name
                , 1 AS authorize
            FROM employees_init e LEFT JOIN authentication a ON a.authentication_id = e.authentication_id
            WHERE e.entity_id IN (
              SELECT dr.owner_id FROM device_relationship dr WHERE
              ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId))
            ) AND a.authorization_level < 400
        ) ea ORDER BY ea.name;

      RETURN QUERY
        SELECT
          *
          , totalRows
        FROM employee_door_auth_init;
  END;
  $BODY$
  LANGUAGE plpgsql;