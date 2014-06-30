-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_message' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_message_read(
    pMessageReadId varchar(32)
    , pMessageId varchar(32)
    , pReaderId varchar(32)
    , pStatus char(1)
)
RETURNS BOOL AS 
$BODY$
DECLARE
    nMessageId varchar(32);
    nReaderId varchar(32);
    nStatus char(1);

    oMessageId varchar(32);
    oReaderId varchar(32);
    oStatus char(1);
BEGIN
    -- Message Read ID is needed if not return
    IF pMessageReadId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            mr.message_id
            , mr.reader_id
            , mr.status
        INTO STRICT
            oMessageId
            , oReaderId
            , oStatus
        FROM message_read mr WHERE
            mr.message_read_id = pMessageReadId;

        -- Start the updating process
        IF pMessageId IS NULL THEN
            nMessageId := oMessageId;
        ELSEIF pMessageId = '' THEN  
            nMessageId := NULL;
        ELSE
            nMessageId := pMessageId;
        END IF;

        IF pReaderId IS NULL THEN 
            nReaderId := oReaderId;
        ELSEIF pReaderId = '' THEN  
            nReaderId := NULL;
        ELSE
            nReaderId := pReaderId;
        END IF;

        IF pStatus IS NULL THEN
            nStatus := oStatus;
        ELSEIF pStatus = '' THEN
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;

        -- start the update
        UPDATE 
            message_read
        SET 
            message_id = nMessageId
            , reader_id = nReaderId
            , status = nStatus
        WHERE
            message_read_id = pMessageReadId;

        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
