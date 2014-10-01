-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'delete_address' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION delete_address(
        pAddressId varchar(32),
        pOwnerId varchar(32)
)
RETURNS BOOLEAN AS
$BODY$
BEGIN
-- Phone ID is needed if not return
    IF pAddressId IS NULL AND pOwnerId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from address WHERE (
		    address_id = pAddressId AND
		    owner_id = pOwnerId
	);
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

