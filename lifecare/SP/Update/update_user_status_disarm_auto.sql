-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_user_status_disarm_auto' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_user_status_disarm_auto(
      pDeviceId varchar(32)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    pEntityId varchar(32);
BEGIN
    -- Get the Entity Id
    SELECT
      owner_id
    INTO
      pEntityId
    FROM device_relationship WHERE
      device_id = pDeviceId;

    -- Set the Entity
    IF pEntityId IS NOT NULL THEN
        -- start the update
        UPDATE
            entity
        SET
            status = 'W'
        WHERE
            entity_id = pEntityId;
    END IF;

    RETURN TRUE;

END;
$BODY$
LANGUAGE plpgsql;