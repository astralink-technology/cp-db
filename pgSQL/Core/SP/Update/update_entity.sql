-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_entity' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_entity(
	pEntityId varchar(32), 
	pFirstName varchar(128),
	pLastName varchar(128),
	pNickName varchar(256),
	pName varchar(256),
	pStatus char(1),
	pApproved boolean,
	pType char(1),
	pLastUpdate timestamp without time zone,
	pAuthenticationId varchar(32),
	pPrimaryEmailId varchar(32),
	pPrimaryPhoneId varchar(32),
	pDateEstablished timestamp without time zone,
	pDisabled boolean
)
RETURNS BOOL AS 
$BODY$
DECLARE
    oFirstName varchar(128);
    oLastName varchar(128);
    oNickName varchar(256);
    oName varchar(256);
    oStatus char(1);
    oApproved boolean;
    oType char(1);
    oLastUpdate timestamp without time zone;
    oAuthenticationId varchar(32);
    oPrimaryEmailId varchar(32);
    oPrimaryPhoneId varchar(32);
    oDateEstablished timestamp without time zone;
    oDisabled boolean;

    nFirstName varchar(128);
    nLastName varchar(128);
    nNickName varchar(256);
    nName varchar(256);
    nStatus char(1);
    nApproved boolean;
    nType char(1);
    nLastUpdate timestamp without time zone;
    nAuthenticationId varchar(32);
    nPrimaryEmailId varchar(32);
    nPrimaryPhoneId varchar(32);
    nDateEstablished timestamp without time zone;
    nDisabled boolean;
BEGIN
    -- Authentication ID is needed if not return
    IF pEntityId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            e.first_name 
            , e.last_name
            , e.nick_name
            , e.name
            , e.status
            , e.approved
            , e.type
            , e.last_update
            , e.authentication_id
            , e.primary_email_id
            , e.primary_phone_id
            , e.disabled
            , e.date_established
        INTO STRICT
            oFirstName
            , oLastName 
            , oNickName 
            , oName 
            , oStatus
            , oApproved
            , oType
            , oLastUpdate
            , oAuthenticationId
            , oPrimaryEmailId
            , oPrimaryPhoneId
            , oDisabled
            , oDateEstablished
        FROM entity e WHERE
            e.entity_id = pEntityId;

        -- Start the updating process
        IF pFirstName IS NULL THEN 
            nFirstName := oFirstName;
        ELSEIF pFirstName = '' THEN  
            nFirstName := NULL;
        ELSE
            nFirstName := pFirstName;
        END IF;

        IF pLastName IS NULL THEN 
            nLastName := oLastName;
        ELSEIF pLastName = '' THEN   
            nLastName := NULL;
        ELSE
            nLastName := pLastName;
        END IF;

        IF pNickName IS NULL THEN 
            nNickName := oNickName;
        ELSEIF pNickName = '' THEN   
            nNickName := NULL;
        ELSE
            nNickName := pNickName;
        END IF;

        IF pName IS NULL THEN 
            nName := oName;
        ELSEIF pName  = '' THEN   
            nName := NULL;
        ELSE
            nName := pName;
        END IF;

        IF pStatus IS NULL THEN 
            nStatus := oStatus;
        ELSEIF pStatus  = '' THEN   
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;

        IF pApproved IS NULL THEN 
            nApproved := oApproved;
        ELSE
            nApproved := pApproved;
        END IF;
        
        IF pDisabled IS NULL THEN
            nDisabled := oDisabled;
        ELSE
            nDisabled := pDisabled;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pType = '' THEN
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;
        
        IF pDateEstablished IS NULL THEN
            nDateEstablished := oDateEstablished;
        ELSE
            nDateEstablished := pDateEstablished;
        END IF;

        IF pAuthenticationId IS NULL THEN 
            nAuthenticationId := oAuthenticationId;
        ELSEIF pAuthenticationId  = '' THEN   
            nAuthenticationId := NULL;
        ELSE
            nAuthenticationId := pAuthenticationId;
        END IF;

        IF pPrimaryEmailId IS NULL THEN 
            nPrimaryEmailId := oPrimaryEmailId;
        ELSEIF pPrimaryEmailId  = '' THEN   
            nPrimaryEmailId := NULL;
        ELSE
            nPrimaryEmailId := pPrimaryEmailId;
        END IF;

        IF pPrimaryPhoneId IS NULL THEN 
            nPrimaryPhoneId := oPrimaryPhoneId;
        ELSEIF pPrimaryPhoneId  = '' THEN   
            nPrimaryPhoneId := NULL;
        ELSE
            nPrimaryPhoneId := pPrimaryPhoneId;
        END IF;

        -- start the update
        UPDATE 
            entity
        SET 
            first_name = nFirstName
            , last_name = nLastName
            , nick_name = nNickName
            , name = nName
            , status = nStatus
            , approved = nApproved
            , type = nType
            , last_update = nLastUpdate
            , authentication_id = nAuthenticationId
            , primary_email_id = nPrimaryEmailId
            , primary_phone_id = nPrimaryPhoneId
            , date_established = nDateEstablished
            , disabled = nDisabled
        WHERE
            entity_id = pEntityId;
        
        RETURN TRUE;
    
    END IF;
END;
$BODY$
LANGUAGE plpgsql;