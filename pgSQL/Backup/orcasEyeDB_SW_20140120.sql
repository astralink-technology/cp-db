--
-- shiweiQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: add_authentication(character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_authentication(pauthenticationid character varying, pauthenticationstring character varying, pauthenticationstringlower character varying, phash character varying, psalt character varying, plastlogin timestamp without time zone, plastlogout timestamp without time zone, plastchangepassword timestamp without time zone, prequestauthenticationstart timestamp without time zone, prequestauthenticationend timestamp without time zone, pauthorizationlevel integer, pcreatedate timestamp without time zone, plastupdate timestamp without time zone) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO authentication (
	authentication_id 
	, authentication_string  
	, authentication_string_lower 
	, hash 
	, salt 
	, last_login 
	, last_logout
	, last_change_password 
	, request_authentication_start 
	, request_authentication_end 
	, authorization_level 
	, create_date
        , last_update                            
    ) VALUES(
        pAuthenticationId 
        , pAuthenticationString 
        , pAuthenticationStringLower 
        , pHash
        , pSalt
        , pLastLogin
        , pLastLogout
        , pLastChangePassword
        , pRequestAuthenticationStart
        , pRequestAuthenticationEnd
        , pAuthorizationLevel
        , pCreateDate
        , pLastUpdate
    );
    RETURN pAuthenticationId;
END;
$$;


ALTER FUNCTION public.add_authentication(pauthenticationid character varying, pauthenticationstring character varying, pauthenticationstringlower character varying, phash character varying, psalt character varying, plastlogin timestamp without time zone, plastlogout timestamp without time zone, plastchangepassword timestamp without time zone, prequestauthenticationstart timestamp without time zone, prequestauthenticationend timestamp without time zone, pauthorizationlevel integer, pcreatedate timestamp without time zone, plastupdate timestamp without time zone) OWNER TO shiwei;

--
-- Name: add_configuration(character varying, character varying, text, character varying, character varying, character varying, text, character varying, character, character varying, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_configuration(pconfigurationid character varying, pname character varying, pfileurl text, pvaluehash character varying, pvalue2hash character varying, pvalue3hash character varying, pdescription text, psalt character varying, ptype character, penterpriseid character varying, pcreatedate timestamp without time zone, plastupdate timestamp without time zone) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO configuration (
	configuration_id 
	, name 
        , file_url
        , value_hash 
	, value2_hash
	, value3_hash
	, description
        , salt
	, type
        , enterprise_id
	, create_date 
	, last_update 
    ) VALUES(
	pConfigurationId
	, pName
        , pFileUrl 
        , pValueHash 
	, pValue2Hash
	, pValue3Hash
	, pDescription 
        , pSalt 
	, pType 
        , pEnterpriseId
	, pCreateDate 
	, pLastUpdate 
    );
    RETURN pConfigurationId;
END;
$$;


ALTER FUNCTION public.add_configuration(pconfigurationid character varying, pname character varying, pfileurl text, pvaluehash character varying, pvalue2hash character varying, pvalue3hash character varying, pdescription text, psalt character varying, ptype character, penterpriseid character varying, pcreatedate timestamp without time zone, plastupdate timestamp without time zone) OWNER TO shiwei;

--
-- Name: add_device(character varying, character varying, character varying, character, character, character, text, timestamp without time zone, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_device(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, pdescription text, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pentityid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO device(
	device_id 
	, name
	, code
	, status 
	, type
	, type2
	, description
	, create_date
	, last_update
	, entity_id
    ) VALUES(
	pDeviceId
	, pName
	, pCode
	, pStatus
	, pType
	, pType2
	, pDescription
	, pCreateDate
	, pLastUpdate
	, pEntityId 
    );
    RETURN pDeviceId;
END;
$$;


ALTER FUNCTION public.add_device(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, pdescription text, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pentityid character varying) OWNER TO shiwei;

--
-- Name: add_device_relationship(character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_device_relationship(pdevicerelationshipid character varying, prelationshipname character varying, pdeviceid character varying, pdevice2id character varying, pentityid character varying, plastupdate timestamp without time zone, pcreatedate timestamp without time zone) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO device_relationship(
      device_relationship_id
      , relationship_name
      , device_id
      , device_2_id
      , entity_id
      , last_update
      , create_date
    ) VALUES(
	pDeviceRelationshipId
      , pRelationshipName
      , pDeviceId
      , pDevice2Id
      , pEntityId
      , pLastUpdate
      , pCreateDate
    );
    RETURN pDeviceRelationshipId;
END;
$$;


ALTER FUNCTION public.add_device_relationship(pdevicerelationshipid character varying, prelationshipname character varying, pdeviceid character varying, pdevice2id character varying, pentityid character varying, plastupdate timestamp without time zone, pcreatedate timestamp without time zone) OWNER TO shiwei;

--
-- Name: add_device_session(character varying, character varying, character, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_device_session(pdeviceid character varying, pconnecteddeviceid character varying, pstatus character, pcreatedate timestamp without time zone) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO device_session(
      device_id
      , connected_device_id
      , status
      , create_date
    ) VALUES(
      pDeviceId
      , pConnectedDeviceId
      , pStatus
      , pCreateDate
    );
    RETURN pDeviceId;
END;
$$;


ALTER FUNCTION public.add_device_session(pdeviceid character varying, pconnecteddeviceid character varying, pstatus character, pcreatedate timestamp without time zone) OWNER TO shiwei;

--
-- Name: add_device_value(character varying, character, character, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying, text); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_device_value(pdevicevalueid character varying, ppush character, psms character, ptoken character varying, ptype character varying, presolution character varying, pquality character varying, phash character varying, psalt character varying, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pdeviceid character varying, pdescription text) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO device_value(
        device_value_id
        , push
        , sms
        , token
        , type
        , resolution
	      , quality
        , hash
        , salt
        , create_date
        , last_update
        , device_id
	, description
    ) VALUES(
        pDeviceValueId
        , pPush
        , pSms
        , pToken
        , pType
        , pResolution
        , pQuality
        , pHash
        , pSalt
        , pCreateDate
        , pLastUpdate
        , pDeviceId
	      , pDescription
    );
    RETURN pDeviceId;
END;
$$;


ALTER FUNCTION public.add_device_value(pdevicevalueid character varying, ppush character, psms character, ptoken character varying, ptype character varying, presolution character varying, pquality character varying, phash character varying, psalt character varying, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pdeviceid character varying, pdescription text) OWNER TO shiwei;

--
-- Name: add_device_with_values(character varying, character varying, character varying, character, character, character, text, timestamp without time zone, timestamp without time zone, character varying, character varying, character, character, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, text); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_device_with_values(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, pdescription text, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pentityid character varying, pdevicevalueid character varying, ppush character, psms character, ptoken character varying, pdevicevaluetype character varying, presolution character varying, pquality character varying, phash character varying, psalt character varying, pdevicevaluecreatedate timestamp without time zone, pdevicevaluelastupdate timestamp without time zone, pdevicevaluedescription text) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO device(
      device_id
      , name
      , code
      , status
      , type
      , type2
      , description
      , create_date
      , last_update
      , entity_id
    ) VALUES(
      pDeviceId
      , pName
      , pCode
      , pStatus
      , pType
      , pType2
      , pDescription
      , pCreateDate
      , pLastUpdate
      , pEntityId
    );

    INSERT INTO device_value(
        device_value_id
        , push
        , sms
        , token
        , type
        , resolution
        , quality
        , hash
        , salt
        , create_date
        , last_update
        , device_id
        , description
    ) VALUES(
        pDeviceValueId
        , pPush
        , pSms
        , pToken
        , pDeviceValueType
        , pResolution
        , pQuality
        , pHash
        , pSalt
        , pDeviceValueCreateDate
        , pDeviceValueLastUpdate
        , pDeviceId
        , pDeviceValueDescription
    );
    RETURN pDeviceId;
END;
$$;


ALTER FUNCTION public.add_device_with_values(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, pdescription text, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pentityid character varying, pdevicevalueid character varying, ppush character, psms character, ptoken character varying, pdevicevaluetype character varying, presolution character varying, pquality character varying, phash character varying, psalt character varying, pdevicevaluecreatedate timestamp without time zone, pdevicevaluelastupdate timestamp without time zone, pdevicevaluedescription text) OWNER TO shiwei;

--
-- Name: add_email(character varying, character varying, timestamp without time zone, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_email(pemailid character varying, pemailaddress character varying, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pentityid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO email (
	email_id 
	, email_address 
	, create_date
	, last_update
	, entity_id
    ) VALUES(
        pEmailId
        , pEmailAddress
        , pCreateDate
        , pLastUpdate
        , pEntityId 
    );
    RETURN pEmailId;
END;
$$;


ALTER FUNCTION public.add_email(pemailid character varying, pemailaddress character varying, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pentityid character varying) OWNER TO shiwei;

--
-- Name: add_enterprise(character varying, character varying, character varying, text, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_enterprise(penterpriseid character varying, pname character varying, pcode character varying, pdescription text, pcreatedate timestamp without time zone, plastupdate timestamp without time zone) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO enterprise (
	enterpriseId 
        , name
        , code
        , description
        , createDate
	, lastUpdate
    ) VALUES(
	pEnterpriseId
        , pName
        , pCode
        , pDescription
        , pCreateDate
	, pLastUpdate
    );
    RETURN pEnterpriseId;
END;
$$;


ALTER FUNCTION public.add_enterprise(penterpriseid character varying, pname character varying, pcode character varying, pdescription text, pcreatedate timestamp without time zone, plastupdate timestamp without time zone) OWNER TO shiwei;

--
-- Name: add_entity(character varying, character varying, character varying, character varying, character varying, character, boolean, character, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_entity(pentityid character varying, pfirstname character varying, plastname character varying, pnickname character varying, pname character varying, pstatus character, papproved boolean, ptype character, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pauthenticationid character varying, pprimaryemailid character varying, pprimaryphoneid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO entity (
	entity_id 
	, first_name 
	, last_name
	, nick_name
	, name
	, status
	, approved
	, type
	, create_date
	, last_update
	, authentication_id
	, primary_email_id
	, primary_phone_id
    ) VALUES(
	pEntityId 
	, pFirstName
	, pLastName
	, pNickName
	, pName
	, pStatus
	, pApproved
	, pType
	, pCreateDate
	, pLastUpdate
	, pAuthenticationId
	, pPrimaryEmailId
	, pPrimaryPhoneId
    );
    RETURN pEntityId;
END;
$$;


ALTER FUNCTION public.add_entity(pentityid character varying, pfirstname character varying, plastname character varying, pnickname character varying, pname character varying, pstatus character, papproved boolean, ptype character, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pauthenticationid character varying, pprimaryemailid character varying, pprimaryphoneid character varying) OWNER TO shiwei;

--
-- Name: add_log(character varying, text, character varying, character varying, text, character, timestamp without time zone, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_log(plogid character varying, pmessage text, ptitle character varying, ptype character varying, plogurl text, pstatus character, pcreatedate timestamp without time zone, pentityid character varying, pdeviceid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO log(
	log_id 
	, message
	, title
	, type
	, log_url
	, status
	, create_date
	, entity_id
	, device_id
    ) VALUES(
	pLogId
	, pMessage
	, pTitle
	, pType
	, pLogUrl
	, pStatus 
	, pCreateDate
	, pEntityId
	, pDeviceId
    );
    RETURN pLogId;
END;
$$;


ALTER FUNCTION public.add_log(plogid character varying, pmessage text, ptitle character varying, ptype character varying, plogurl text, pstatus character, pcreatedate timestamp without time zone, pentityid character varying, pdeviceid character varying) OWNER TO shiwei;

--
-- Name: add_media(character varying, character varying, character, text, text, character, timestamp without time zone, text, character varying, text, text, text, text, character varying, character varying, numeric); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_media(pmediaid character varying, ptitle character varying, ptype character, pfilename text, pmediaurl text, pstatus character, pcreatedate timestamp without time zone, pdescription text, pfiletype character varying, pimgurl text, pimgurl2 text, pimgurl3 text, pimgurl4 text, pdeviceid character varying, pentityid character varying, pfilesize numeric) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO media(
	media_id
	, title 
	, type
  , filename
	, media_url
	, status 
	, create_date
	, description
	, file_type
	, img_url
	, img_url2
	, img_url3
	, img_url4
	, device_id
	, entity_id
	, filesize
    ) VALUES(
	pMediaId
	, pTitle
	, pType
  , pFilename
	, pMediaUrl
	, pStatus
	, pCreateDate
	, pDescription
	, pFileType
	, pImgUrl
	, pImgUrl2
	, pImgUrl3
	, pImgUrl4
	, pDeviceId
	, pEntityId
	, pFileSize
    );
    RETURN pMediaId;
END;
$$;


ALTER FUNCTION public.add_media(pmediaid character varying, ptitle character varying, ptype character, pfilename text, pmediaurl text, pstatus character, pcreatedate timestamp without time zone, pdescription text, pfiletype character varying, pimgurl text, pimgurl2 text, pimgurl3 text, pimgurl4 text, pdeviceid character varying, pentityid character varying, pfilesize numeric) OWNER TO shiwei;

--
-- Name: add_message(character varying, text, character, timestamp without time zone, timestamp without time zone, character varying, character); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_message(pmessageid character varying, pmessage text, ptype character, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pownerid character varying, ptriggerevent character) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO message (
	message_id 
	, message
	, type
	, create_date
	, last_update
	, owner_id
	, trigger_event
    ) VALUES(
        pMessageId
        , pMessage
        , pType
        , pCreateDate
        , pLastUpdate
        , pOwnerId 
        , pTriggerEvent 
    );
    RETURN pMessageId;
END;
$$;


ALTER FUNCTION public.add_message(pmessageid character varying, pmessage text, ptype character, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pownerid character varying, ptriggerevent character) OWNER TO shiwei;

--
-- Name: add_phone(character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_phone(pphoneid character varying, pphonedigits character varying, pdigits character varying, pcountrycode character varying, pcode character varying, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pentityid character varying, pdeviceid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO phone (
	phone_id 
	, phone_digits 
	, digits
	, country_code
	, code
	, create_date 
	, last_update 
	, entity_id
	, device_id
    ) VALUES(
        pPhoneId 
        , pPhoneDigits 
        , pDigits
        , pCountryCode
        , pCode
        , pCreateDate
        , pLastUpdate
        , pEntityId
        , pDeviceId
    );
    RETURN pPhoneId;
END;
$$;


ALTER FUNCTION public.add_phone(pphoneid character varying, pphonedigits character varying, pdigits character varying, pcountrycode character varying, pcode character varying, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pentityid character varying, pdeviceid character varying) OWNER TO shiwei;

--
-- Name: add_product(character varying, character varying, text, character, character, character varying, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_product(pproductid character varying, pname character varying, pdescription text, pstatus character, ptype character, pcode character varying, pcreatedate timestamp without time zone, plastupdate timestamp without time zone) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO product(
        product_id
        , name
        , description
        , status
        , type
        , code
        , create_date
        , last_update
    ) VALUES(
        pProductId
        , pName
        , pDescription
        , pStatus
        , pType
        , pCode
        , pCreateDate
	      , pLastUpdate
    );
    RETURN pProductId;
END;
$$;


ALTER FUNCTION public.add_product(pproductid character varying, pname character varying, pdescription text, pstatus character, ptype character, pcode character varying, pcreatedate timestamp without time zone, plastupdate timestamp without time zone) OWNER TO shiwei;

--
-- Name: add_product(character varying, character varying, numeric, numeric, numeric, character varying, character, character, timestamp without time zone, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_product(pproductvalueid character varying, pproductvaluename character varying, pvalue numeric, pvalue2 numeric, pvalue3 numeric, pvalueunit character varying, pstatus character, ptype character, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pproductid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO product_value(
      product_value_id
      , product_value_name
      , value
      , value2
      , value3
      , value_unit
      , status
      , type
      , create_date
      , last_update
      , product_id
    ) VALUES(
        pProductValueId
      , pProductValueName
      , pValue
      , pValue2
      , pValue3
      , pValueUnit
      , pStatus
      , pType
      , pCreateDate
      , pLastUpdate
      , pProductId
    );
    RETURN pProductValueId;
END;
$$;


ALTER FUNCTION public.add_product(pproductvalueid character varying, pproductvaluename character varying, pvalue numeric, pvalue2 numeric, pvalue3 numeric, pvalueunit character varying, pstatus character, ptype character, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pproductid character varying) OWNER TO shiwei;

--
-- Name: add_product_registration(character varying, character, character, timestamp without time zone, timestamp without time zone, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_product_registration(pproductregistrationid character varying, pstatus character, ptype character, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pproductid character varying, pentityid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO product_registration(
		product_registration_id,
		status,
		type,
		create_date,
		last_update,
		product_id,
		entity_id
    ) VALUES(
		pProductRegistrationId,
		pStatus,
		pType,
		pCreateDate,
		pLastUpdate,
		pProductId,
		pEntityId
    );
    RETURN pProductRegistrationId;
END;
$$;


ALTER FUNCTION public.add_product_registration(pproductregistrationid character varying, pstatus character, ptype character, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pproductid character varying, pentityid character varying) OWNER TO shiwei;

--
-- Name: add_product_value(character varying, character varying, numeric, numeric, numeric, character varying, character, character, timestamp without time zone, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION add_product_value(pproductvalueid character varying, pproductvaluename character varying, pvalue numeric, pvalue2 numeric, pvalue3 numeric, pvalueunit character varying, pstatus character, ptype character, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pproductid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO product_value(
      product_value_id
      , product_value_name
      , value
      , value2
      , value3
      , value_unit
      , status
      , type
      , create_date
      , last_update
      , product_id
    ) VALUES(
        pProductValueId
      , pProductValueName
      , pValue
      , pValue2
      , pValue3
      , pValueUnit
      , pStatus
      , pType
      , pCreateDate
      , pLastUpdate
      , pProductId
    );
    RETURN pProductValueId;
END;
$$;


ALTER FUNCTION public.add_product_value(pproductvalueid character varying, pproductvaluename character varying, pvalue numeric, pvalue2 numeric, pvalue3 numeric, pvalueunit character varying, pstatus character, ptype character, pcreatedate timestamp without time zone, plastupdate timestamp without time zone, pproductid character varying) OWNER TO shiwei;

--
-- Name: delete_authentication(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_authentication(pauthenticationid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Authentication ID is needed if not return
    IF pAuthenticationId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from authentication where 
        authentication_id = pAuthenticationId;
        
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_authentication(pauthenticationid character varying) OWNER TO shiwei;

--
-- Name: delete_configuration(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_configuration(pconfigurationid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Configuration ID is needed if not return
    IF pConfigurationId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from configuration where 
        configuration_id = pConfigurationId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_configuration(pconfigurationid character varying) OWNER TO shiwei;

--
-- Name: delete_device(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_device(pdeviceid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Phone ID is needed if not return
    IF pDeviceId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from device d where (
	      d.device_id = pDeviceId
	);
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_device(pdeviceid character varying) OWNER TO shiwei;

--
-- Name: delete_device_relationship(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_device_relationship(pdevicerelationshipid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Phone ID is needed if not return
    IF pDeviceRelationshipId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from device_relationship where 
        device_relationship_id = pDeviceRelationshipId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_device_relationship(pdevicerelationshipid character varying) OWNER TO shiwei;

--
-- Name: delete_device_session(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_device_session(pdeviceid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Device ID is needed if not return
    IF pDeviceId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from device_session where 
        device_id = pDeviceId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_device_session(pdeviceid character varying) OWNER TO shiwei;

--
-- Name: delete_device_value(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_device_value(pdevicevalueid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF pDeviceValueId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from device_value where
        device_value_id = pDeviceValueId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_device_value(pdevicevalueid character varying) OWNER TO shiwei;

--
-- Name: delete_device_value(character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_device_value(pdevicevalueid character varying, pdeviceid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF pDeviceValueId IS NULL AND pDeviceId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from device_value WHERE (
        device_id = pDeviceId OR
        device_value_id = pDeviceValueId
	);
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_device_value(pdevicevalueid character varying, pdeviceid character varying) OWNER TO shiwei;

--
-- Name: delete_email(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_email(pemailid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Email ID is needed if not return
    IF pEmailId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from email where 
        email_id = pEmailId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_email(pemailid character varying) OWNER TO shiwei;

--
-- Name: delete_enterprise(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_enterprise(penterpriseid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Enterprise ID is needed if not return
    IF pEnterpriseId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from enterprise where 
        enterprise_id = pEnterpriseId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_enterprise(penterpriseid character varying) OWNER TO shiwei;

--
-- Name: delete_log(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_log(plogid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Log ID is needed if not return
    IF pLogId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from log where 
        log_id = pLogId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_log(plogid character varying) OWNER TO shiwei;

--
-- Name: delete_media(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_media(pmediaid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Log ID is needed if not return
    IF pMediaId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from media where 
        media_id = pMediaId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_media(pmediaid character varying) OWNER TO shiwei;

--
-- Name: delete_message(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_message(pmessageid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Message ID is needed if not return
    IF pMessageId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from message where 
        message_id = pMessageId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_message(pmessageid character varying) OWNER TO shiwei;

--
-- Name: delete_message_by_device_id(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_message_by_device_id(pdeviceid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Device ID is needed if not return
    IF pDeviceId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from message where 
        owner_id = pDeviceId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_message_by_device_id(pdeviceid character varying) OWNER TO shiwei;

--
-- Name: delete_phone(character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_phone(pphoneid character varying, pdeviceid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Phone ID is needed if not return
    IF pPhoneId IS NULL AND pDeviceId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from phone WHERE (
		    phone_id = pPhoneId OR
		    device_id = pDeviceId
	);
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_phone(pphoneid character varying, pdeviceid character varying) OWNER TO shiwei;

--
-- Name: delete_product(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_product(pproductid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF pProductId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from product where 
        product_id = pProductId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_product(pproductid character varying) OWNER TO shiwei;

--
-- Name: delete_product_registration(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_product_registration(pproductregistrationid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF pProductRegistrationId IS NULL THEN  
        RETURN FALSE;
    ELSE
        DELETE from product_registration where 
        product_registration_id = pProductRegistrationId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_product_registration(pproductregistrationid character varying) OWNER TO shiwei;

--
-- Name: delete_product_value(character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION delete_product_value(pproducvalueid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF pProducValueId IS NULL THEN
        RETURN FALSE;
    ELSE
        DELETE from product_value where
        product_value_id = pProducValueId;
        RETURN TRUE;
    END IF;
END;
$$;


ALTER FUNCTION public.delete_product_value(pproducvalueid character varying) OWNER TO shiwei;

--
-- Name: get_admin_entity_detail(character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_admin_entity_detail(pentityid character varying, pauthenticationid character varying) RETURNS TABLE(entity_id character varying, first_name character varying, last_name character varying, nick_name character varying, name character varying, status character, approved boolean, type character, create_date timestamp without time zone, last_update timestamp without time zone, authentication_id character varying, primary_email_id character varying, primary_phone_id character varying, authorization_level integer, last_login timestamp without time zone, last_logout timestamp without time zone, authentication_string character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
      e.entity_id
      , e.first_name
      , e.last_name
      , e.nick_name
      , e.name
      , e.status
      , e.approved
      , e.type
      , a.create_date -- user create date
      , e.last_update
      , e.authentication_id
      , e.primary_email_id
      , e.primary_phone_id
      , a.authorization_level
      , a.last_login
      , a.last_logout
      , a.authentication_string
    FROM entity e INNER JOIN
    authentication a ON a.authentication_id = e.authentication_id WHERE (
    ((pEntityId IS NULL) OR (e.entity_id = pEntityId)) AND
    ((pAuthenticationId IS NULL) OR (e.authentication_id = pAuthenticationId))
	);
END;
$$;


ALTER FUNCTION public.get_admin_entity_detail(pentityid character varying, pauthenticationid character varying) OWNER TO shiwei;

--
-- Name: get_authentication(character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_authentication(pauthenticationid character varying, pauthenticationstringlower character varying) RETURNS TABLE(authentication_id character varying, authentication_string character varying, authentication_string_lower character varying, hash character varying, salt character varying, last_login timestamp without time zone, last_logout timestamp without time zone, last_change_password timestamp without time zone, request_authentication_start timestamp without time zone, request_authentication_end timestamp without time zone, authorization_level integer, create_date timestamp without time zone, last_update timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
	a.authentication_id 
	, a.authentication_string 
	, a.authentication_string_lower 
	, a.hash 
	, a.salt 
	, a.last_login 
	, a.last_logout
	, a.last_change_password 
	, a.request_authentication_start 
	, a.request_authentication_end 
	, a.authorization_level 
	, a.create_date 
        , a.last_update 
    FROM authentication a WHERE (
	((pAuthenticationId IS NULL) OR (a.authentication_id = pAuthenticationId)) AND
	((pAuthenticationStringLower IS NULL) OR (a.authentication_string_lower = pAuthenticationStringLower))
	);
END;
$$;


ALTER FUNCTION public.get_authentication(pauthenticationid character varying, pauthenticationstringlower character varying) OWNER TO shiwei;

--
-- Name: get_configuration(character varying, character varying, text, character, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_configuration(pconfigurationid character varying, pname character varying, pfileurl text, ptype character, penterpriseid character varying) RETURNS TABLE(configuration_id character varying, name character varying, file_url text, value_hash character varying, value2_hash character varying, value3_hash character varying, description text, salt character varying, type character, enterprise_id character varying, create_date timestamp without time zone, last_update timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
	c.configuration_id
	, c.name 
        , c.file_url 
        , c.value_hash 
	, c.value2_hash 
	, c.value3_hash 
	, c.description 
        , c.salt 
	, c.type 
        , c.enterprise_id 
	, c.create_date
	, c.last_update
    FROM configuration c WHERE (
	((pConfigurationId IS NULL) OR (c.configuration_id = pConfigurationId)) AND
	((pName IS NULL) OR (c.name = pName)) AND
	((pFileUrl IS NULL) OR (c.file_url = pFileUrl)) AND
	((pType IS NULL) OR (c.type = pType)) AND
	((pEnterpriseId IS NULL) OR (c.enterprise_id = pEnterpriseId))
	);
END;
$$;


ALTER FUNCTION public.get_configuration(pconfigurationid character varying, pname character varying, pfileurl text, ptype character, penterpriseid character varying) OWNER TO shiwei;

--
-- Name: get_device(character varying, character varying, character varying, character, character, character, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_device(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, pentityid character varying) RETURNS TABLE(device_id character varying, name character varying, code character varying, status character, type character, type2 character, description text, create_date timestamp without time zone, last_update timestamp without time zone, entity_id character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
	d.device_id
	, d.name
	, d.code
	, d.status
	, d.type
	, d.type2
	, d.description
	, d.create_date
	, d.last_update
	, d.entity_id
    FROM device d WHERE (
	((pDeviceId IS NULL) OR (d.device_id = pDeviceId)) AND
	((pEntityId IS NULL) OR (d.entity_id = pEntityId)) AND
	((pName IS NULL) OR (d.name = pName)) AND
	((pCode IS NULL) OR (d.code = pCode))AND
	((pStatus IS NULL) OR (d.status = pStatus))AND
	((pType IS NULL) OR (d.type = pType))AND
	((pType2 IS NULL) OR (d.type2 = pType2))
	);
END;
$$;


ALTER FUNCTION public.get_device(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, pentityid character varying) OWNER TO shiwei;

--
-- Name: get_device_details(character varying, character varying, character varying, character, character, character, character, character varying, character, character, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_device_details(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, ppush character, ptoken character varying, psms character, pquality character, presolution character varying, pdevicevaluetype character varying, pentityid character varying) RETURNS TABLE(device_id character varying, device_value_id character varying, name character varying, code character varying, status character, type character, type2 character, description text, push character, token character varying, sms character, quality character varying, resolution character varying, device_value_type character varying, last_update timestamp without time zone, device_last_update timestamp without time zone, entity_id character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
      d.device_id
      , dv.device_value_id
      , d.name
      , d.code
      , d.status
      , d.type
      , d.type2
      , d.description
      , dv.push
      , dv.token
      , dv.sms
      , dv.quality
      , dv.resolution
      , dv.type as device_value_type
      , d.last_update
      , dv.last_update as device_value_last_update
      , d.entity_id
    FROM device d INNER JOIN
    device_value dv ON d.device_id = dv.device_id WHERE
    (
      ((pDeviceId IS NULL) OR (d.device_id = pDeviceId)) AND
      ((pEntityId IS NULL) OR (d.entity_id = pEntityId)) AND
      ((pName IS NULL) OR (d.name = pName)) AND
      ((pCode IS NULL) OR (d.code = pCode))AND
      ((pStatus IS NULL) OR (d.status = pStatus))AND
      ((pType IS NULL) OR (d.type = pType))AND
      ((pType2 IS NULL) OR (d.type2 = pType2)) AND
      ((pPush IS NULL) OR (dv.push = pPush)) AND
      ((pToken IS NULL) OR (dv.token = pToken)) AND
      ((pSms IS NULL) OR (dv.sms = pSms)) AND
      ((pQuality IS NULL) OR (dv.quality = pQuality)) AND
      ((pResolution IS NULL) OR (dv.resolution = pResolution)) AND
      ((pDeviceValueType IS NULL) OR (dv.type = pDeviceValueType))
  	);
END;
$$;


ALTER FUNCTION public.get_device_details(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, ppush character, ptoken character varying, psms character, pquality character, presolution character varying, pdevicevaluetype character varying, pentityid character varying) OWNER TO shiwei;

--
-- Name: get_device_relationship(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_device_relationship(pdevicerelationshipid character varying, prelationshipname character varying, pdeviceid character varying, pdevice2id character varying, pentityid character varying) RETURNS TABLE(device_relationship_id character varying, relationship_name character varying, device_id character varying, device_2_id character varying, entity_id character varying, last_update timestamp without time zone, create_date timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
	dr.device_relationship_id
	, dr.relationship_name
	, dr.device_id
	, dr.device_2_id
	, dr.entity_id
	, dr.last_update
	, dr.create_date
    FROM device_relationship dr WHERE (
	((pDeviceRelationshipId IS NULL) OR (dr.device_relationship_id = pDeviceRelationshipId)) AND
	((pDeviceId IS NULL) OR (dr.device_id = pDeviceId)) AND
	((pDevice2Id IS NULL) OR (dr.device_2_id = pDevice2Id)) AND
	((pEntityId IS NULL) OR (dr.entity_id = pEntityId))
	);
END;
$$;


ALTER FUNCTION public.get_device_relationship(pdevicerelationshipid character varying, prelationshipname character varying, pdeviceid character varying, pdevice2id character varying, pentityid character varying) OWNER TO shiwei;

--
-- Name: get_device_session(character varying, character varying, character); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_device_session(pdeviceid character varying, pconnecteddeviceid character varying, pstatus character) RETURNS TABLE(device_id character varying, connected_device_id character varying, status character, create_date timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
	ds.device_id
	, ds.connected_device_id
	, ds.status
	, ds.create_date
    FROM device_session ds WHERE (
	((pDeviceId IS NULL) OR (ds.device_id = pDeviceId)) AND
	((pConnectedDeviceId IS NULL) OR (ds.connected_device_id = pConnectedDeviceId)) AND
	((pStatus IS NULL) OR (ds.status = pStatus))
	);
END;
$$;


ALTER FUNCTION public.get_device_session(pdeviceid character varying, pconnecteddeviceid character varying, pstatus character) OWNER TO shiwei;

--
-- Name: get_device_value(character varying, character, character, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_device_value(pdevicevalueid character varying, ppush character, psms character, ptoken character varying, ptype character varying, presolution character varying, pquality character varying, pdeviceid character varying) RETURNS TABLE(device_value_id character varying, push character, sms character, token character varying, type character varying, resolution character varying, quality character varying, hash character varying, salt character varying, create_date timestamp without time zone, last_update timestamp without time zone, device_id character varying, description text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
      dv.device_value_id
      , dv.push
      , dv.sms
      , dv.token
      , dv.type
      , dv.resolution
      , dv.quality
      , dv.hash
      , dv.salt
      , dv.create_date
      , dv.last_update
      , dv.device_id
      , dv.description
    FROM device_value dv WHERE (
	((pDeviceValueId = NULL) OR (dv.device_value_id = pDeviceValueId)) OR
	((pDeviceId = NULL) OR (dv.device_id = pDeviceId))
	);
END;
$$;


ALTER FUNCTION public.get_device_value(pdevicevalueid character varying, ppush character, psms character, ptoken character varying, ptype character varying, presolution character varying, pquality character varying, pdeviceid character varying) OWNER TO shiwei;

--
-- Name: get_email(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_email(pemailid character varying, pemailaddress character varying, pentityid character varying) RETURNS TABLE(email_id character varying, email_address character varying, create_date timestamp without time zone, last_update timestamp without time zone, entity_id character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
	e.email_id 
	, e.email_address
	, e.create_date
	, e.last_update
	, e.entity_id
    FROM email e WHERE (
	((pEmailId IS NULL) OR (e.email_id= pEmailId)) AND
	((pEmailAddress IS NULL) OR (e.email_address = pEmailAddress)) AND
	((pEntityId IS NULL) OR (e.entity_id = pEntityId))
	);
END;
$$;


ALTER FUNCTION public.get_email(pemailid character varying, pemailaddress character varying, pentityid character varying) OWNER TO shiwei;

--
-- Name: get_enterprise(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_enterprise(penterpriseid character varying, pname character varying, pcode character varying) RETURNS TABLE(enterprise_id character varying, name character varying, code character varying, description text, create_date timestamp without time zone, last_update timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
	e.enterprise_id
        , e.name 
        , e.code 
        , e.description 
        , e.create_date 
	, e.last_update
    FROM enterprise e WHERE (
	((pEnterpriseId IS NULL) OR (e.enterpriseId = pEnterpriseId)) AND
	((pName IS NULL) OR (e.name = pName)) AND
	((pCode IS NULL) OR (e.code = pCode))
	);
END;
$$;


ALTER FUNCTION public.get_enterprise(penterpriseid character varying, pname character varying, pcode character varying) OWNER TO shiwei;

--
-- Name: get_entity(character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_entity(pentityid character varying, pauthenticationid character varying) RETURNS TABLE(entity_id character varying, first_name character varying, last_name character varying, nick_name character varying, name character varying, status character, approved boolean, type character, create_date timestamp without time zone, last_update timestamp without time zone, authentication_id character varying, primary_email_id character varying, primary_phone_id character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
	e.entity_id 
	, e.first_name 
	, e.last_name 
	, e.nick_name 
	, e.name
	, e.status
	, e.approved 
	, e.type 
	, e.create_date 
	, e.last_update
	, e.authentication_id
	, e.primary_email_id 
	, e.primary_phone_id
    FROM entity e WHERE (
    ((pEntityId IS NULL) OR (e.entity_id = pEntityId)) AND
    ((pAuthenticationId IS NULL) OR (e.authentication_id = pAuthenticationId))
	);
END;
$$;


ALTER FUNCTION public.get_entity(pentityid character varying, pauthenticationid character varying) OWNER TO shiwei;

--
-- Name: get_entity_device(character varying, character varying, character varying, character, character, character, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_entity_device(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, pentityid character varying) RETURNS TABLE(device_id character varying, name character varying, code character varying, status character, type character, type2 character, description text, create_date timestamp without time zone, last_update timestamp without time zone, entity_id character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
	d.device_id
	, d.name
	, d.code
	, d.status
	, d.type
	, d.type2
	, d.description
	, d.create_date
	, d.last_update
	, d.entity_id
    FROM device d
    INNER JOIN device_relationship dr ON dr.device_id = d.device_id WHERE (
      ((pDeviceId IS NULL) OR (d.device_id = pDeviceId)) AND
      ((pEntityId IS NULL) OR (dr.entity_id = pEntityId)) AND
      ((pName IS NULL) OR (d.name = pName)) AND
      ((pCode IS NULL) OR (d.code = pCode))AND
      ((pStatus IS NULL) OR (d.status = pStatus))AND
      ((pType IS NULL) OR (d.type = pType))AND
      ((pType2 IS NULL) OR (d.type2 = pType2))
	);
END;
$$;


ALTER FUNCTION public.get_entity_device(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, pentityid character varying) OWNER TO shiwei;

--
-- Name: get_entity_device_details(character varying, character varying, character varying, character, character, character, character, character varying, character, character, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_entity_device_details(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, ppush character, ptoken character varying, psms character, pquality character, presolution character varying, pdevicevaluetype character varying, pentityid character varying) RETURNS TABLE(device_id character varying, device_value_id character varying, name character varying, code character varying, status character, type character, type2 character, description text, push character, token character varying, sms character, quality character varying, resolution character varying, device_value_type character varying, last_update timestamp without time zone, device_last_update timestamp without time zone, entity_id character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
      d.device_id
      , dv.device_value_id
      , d.name
      , d.code
      , d.status
      , d.type
      , d.type2
      , d.description
      , dv.push
      , dv.token
      , dv.sms
      , dv.quality
      , dv.resolution
      , dv.type as device_value_type
      , d.last_update
      , dv.last_update as device_value_last_update
      , d.entity_id
    FROM device d INNER JOIN
    device_value dv ON d.device_id = dv.device_id INNER JOIN
    device_relationship dr ON dr.device_id = d.device_id WHERE
    (
      ((pDeviceId IS NULL) OR (d.device_id = pDeviceId)) AND
      ((pEntityId IS NULL) OR (dr.entity_id = pEntityId)) AND
      ((pName IS NULL) OR (d.name = pName)) AND
      ((pCode IS NULL) OR (d.code = pCode))AND
      ((pStatus IS NULL) OR (d.status = pStatus))AND
      ((pType IS NULL) OR (d.type = pType))AND
      ((pType2 IS NULL) OR (d.type2 = pType2)) AND
      ((pPush IS NULL) OR (dv.push = pPush)) AND
      ((pToken IS NULL) OR (dv.token = pToken)) AND
      ((pSms IS NULL) OR (dv.sms = pSms)) AND
      ((pQuality IS NULL) OR (dv.quality = pQuality)) AND
      ((pResolution IS NULL) OR (dv.resolution = pResolution)) AND
      ((pDeviceValueType IS NULL) OR (dv.type = pDeviceValueType))
  	);
END;
$$;


ALTER FUNCTION public.get_entity_device_details(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, ppush character, ptoken character varying, psms character, pquality character, presolution character varying, pdevicevaluetype character varying, pentityid character varying) OWNER TO shiwei;

--
-- Name: get_log(character varying, text, character varying, character varying, text, character, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_log(plogid character varying, pmessage text, ptitle character varying, ptype character varying, plogurl text, pstatus character, pentityid character varying, pdeviceid character varying) RETURNS TABLE(log_id character varying, message text, title character varying, type character varying, log_url text, status character, create_date timestamp without time zone, entity_id character varying, device_id character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
	l.log_id
	, l.message 
	, l.title
	, l.type 
	, l.log_url 
	, l.status 
	, l.create_date 
	, l.entity_id 
	, l.device_id 
    FROM log l WHERE (
	((pLogId IS NULL) OR (l.log_id = pLogId)) AND
	((pMessage IS NULL) OR (l.message = pMessage)) AND
	((pTitle IS NULL) OR (l.title = pTitle))AND
	((pType IS NULL) OR (l.type = pType))AND
	((pLogUrl IS NULL) OR (l.log_url = pLogUrl))AND
	((pStatus IS NULL) OR (l.status = pStatus)) AND
	((pEntityId IS NULL) OR (l.entity_id = pEntityId))AND
	((pDeviceId IS NULL) OR (l.device_id = pDeviceId))
	);
END;
$$;


ALTER FUNCTION public.get_log(plogid character varying, pmessage text, ptitle character varying, ptype character varying, plogurl text, pstatus character, pentityid character varying, pdeviceid character varying) OWNER TO shiwei;

--
-- Name: get_media(character varying, character varying, character, text, text, character, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_media(pmediaid character varying, ptitle character varying, ptype character, pfilename text, pmediaurl text, pstatus character, pfiletype character varying, pdeviceid character varying, pentityid character varying) RETURNS TABLE(media_id character varying, title character varying, type character, filename text, media_url text, status character, description text, file_type character varying, image_url text, image_url2 text, image_url3 text, image_url4 text, create_date timestamp without time zone, device_id character varying, entity_id character varying, filesize numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
    m.media_id
    , m.title
    , m.type
    , m.filename
    , m.media_url
    , m.status
    , m.description
    , m.file_type
    , m.img_url
    , m.img_url2
    , m.img_url3
    , m.img_url4
    , m.create_date
    , m.device_id
    , m.entity_id
    , m.filesize
    FROM media m WHERE (
      ((pMediaId IS NULL) OR (m.media_id = pMediaId)) AND
      ((pTitle IS NULL) OR (m.title = pTitle)) AND
      ((pType IS NULL) OR (m.type = pType))AND
      ((pFilename IS NULL) OR (m.filename = pFilename))AND
      ((pMediaUrl IS NULL) OR (m.media_url = pMediaUrl))AND
      ((pStatus IS NULL) OR (m.status = pStatus))AND
      ((pFileType IS NULL) OR (m.file_type = pFileType))AND
      ((pDeviceId IS NULL) OR (m.device_id = pDeviceId))AND
      ((pEntityId IS NULL) OR (m.entity_id = pEntityId))
	);
END;
$$;


ALTER FUNCTION public.get_media(pmediaid character varying, ptitle character varying, ptype character, pfilename text, pmediaurl text, pstatus character, pfiletype character varying, pdeviceid character varying, pentityid character varying) OWNER TO shiwei;

--
-- Name: get_message(character varying, text, character, character varying, character); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_message(pmessageid character varying, pmessage text, ptype character, pownerid character varying, ptriggerevent character) RETURNS TABLE(message_id character varying, message text, type character, create_date timestamp without time zone, last_update timestamp without time zone, owner_id character varying, trigger_event character)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
	e.message_id 
	, e.message
	, e.type
	, e.create_date
	, e.last_update
	, e.owner_id
	, e.trigger_event
    FROM message e WHERE (
	((pMessageId IS NULL) OR (e.message_id= pMessageId)) AND
	((pMessage IS NULL) OR (e.message = pMessage)) AND
	((pType IS NULL) OR (e.type = pType)) AND
	((pOwnerId IS NULL) OR (e.owner_id = pOwnerId)) AND
	((pTriggerEvent IS NULL) OR (e.trigger_event = pTriggerEvent))
	);
END;
$$;


ALTER FUNCTION public.get_message(pmessageid character varying, pmessage text, ptype character, pownerid character varying, ptriggerevent character) OWNER TO shiwei;

--
-- Name: get_phone(character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_phone(pphoneid character varying, pphonedigits character varying, pdigits character varying, pcountrycode character varying, pcode character varying, pentityid character varying, pdeviceid character varying) RETURNS TABLE(phone_id character varying, phone_digits character varying, digits character varying, country_code character varying, code character varying, create_date timestamp without time zone, last_update timestamp without time zone, entity_id character varying, device_id character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
	p.phone_id
	, p.phone_digits
	, p.digits
	, p.country_code
	, p.code
	, p.create_date
	, p.last_update
	, p.entity_id
	, p.device_id
    FROM phone p WHERE (
	((pPhoneId IS NULL) OR (p.phone_id = pPhoneId)) AND
	((pPhoneDigits IS NULL) OR (p.phone_digits = pPhoneDigits)) AND
	((pDigits IS NULL) OR (p.digits = pDigits)) AND
	((pCountryCode IS NULL) OR (p.country_code = pCountryCode)) AND
	((pCode IS NULL) OR (p.code = pCode)) AND
	((pEntityId IS NULL) OR (p.entity_id = pEntityId)) AND
	((pDeviceId IS NULL) OR (p.device_id = pDeviceId))
	);
END;
$$;


ALTER FUNCTION public.get_phone(pphoneid character varying, pphonedigits character varying, pdigits character varying, pcountrycode character varying, pcode character varying, pentityid character varying, pdeviceid character varying) OWNER TO shiwei;

--
-- Name: get_product(character varying, character varying, character, character, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_product(pproductid character varying, pname character varying, pstatus character, ptype character, pcode character varying) RETURNS TABLE(product_id character varying, name character varying, description text, code character varying, type character, status character, create_date timestamp without time zone, last_update timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
      p.product_id
      , p.name
      , p.description
      , p.code
      , p.status
      , p.type
      , p.create_date
      , p.last_update
    FROM product p  WHERE (
      ((pProductId IS NULL) OR (p.product_id = pProductId)) AND
      ((pName IS NULL) OR (p.name = pName)) AND
      ((pType IS NULL) OR (p.type = pType)) AND
      ((pCode IS NULL) OR (p.code = pCode)) AND
      ((pStatus IS NULL) OR (p.status = pStatus))
	);
END;
$$;


ALTER FUNCTION public.get_product(pproductid character varying, pname character varying, pstatus character, ptype character, pcode character varying) OWNER TO shiwei;

--
-- Name: get_product_registration(character varying, character, character, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_product_registration(pproductregistrationid character varying, pstatus character, ptype character, pproductid character varying, pentityid character varying) RETURNS TABLE(product_registration_id character varying, status character, type character, create_date timestamp without time zone, last_update timestamp without time zone, product_id character varying, entity_id character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
      pr.product_registration_id,
      pr.status,
      pr.type,
      pr.create_date,
      pr.last_update,
      pr.product_id,
      pr.entity_id
    FROM product_registration pr  WHERE (
      ((pProductRegistrationId IS NULL) OR (pr.product_registration_id = pProductRegistrationId)) AND
      ((pStatus IS NULL) OR (pr.status = pStatus))AND
      ((pType IS NULL) OR (pr.Type = pType))AND
      ((pProductId IS NULL) OR (pr.product_id = pProductId))AND
      ((pEntityId IS NULL) OR (pr.entity_id = pEntityId))
	);
END;
$$;


ALTER FUNCTION public.get_product_registration(pproductregistrationid character varying, pstatus character, ptype character, pproductid character varying, pentityid character varying) OWNER TO shiwei;

--
-- Name: get_product_registration_details(character varying, character, character, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_product_registration_details(pproductregistrationid character varying, pstatus character, ptype character, pproductid character varying, pentityid character varying) RETURNS TABLE(product_registration_id character varying, status character, type character, create_date timestamp without time zone, last_update timestamp without time zone, product_id character varying, entity_id character varying, entity_name character varying, product_name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
      pr.product_registration_id,
      pr.status,
      pr.type,
      pr.create_date,
      pr.last_update,
      pr.product_id,
      pr.entity_id,
      e.name as entity_name,
      p.name as product_name
    FROM product_registration pr INNER JOIN
    entity e ON pr.entity_id = e.entity_id INNER JOIN
    product p ON pr.product_id = p.product_id WHERE (
      ((pProductRegistrationId IS NULL) OR (pr.product_registration_id = pProductRegistrationId)) AND
      ((pStatus IS NULL) OR (pr.status = pStatus))AND
      ((pType IS NULL) OR (pr.Type = pType))AND
      ((pProductId IS NULL) OR (pr.product_id = pProductId))AND
      ((pEntityId IS NULL) OR (pr.entity_id = pEntityId))
	);
END;
$$;


ALTER FUNCTION public.get_product_registration_details(pproductregistrationid character varying, pstatus character, ptype character, pproductid character varying, pentityid character varying) OWNER TO shiwei;

--
-- Name: get_product_value(character varying, character varying, numeric, numeric, numeric, character varying, character, character, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION get_product_value(pproductvalueid character varying, pproductvaluename character varying, pvalue numeric, pvalue2 numeric, pvalue3 numeric, pvalueunit character varying, pstatus character, ptype character, pproductid character varying) RETURNS TABLE(product_value_id character varying, product_value_name character varying, value numeric, value2 numeric, value3 numeric, value_unit character varying, status character, type character, create_date timestamp without time zone, last_update timestamp without time zone, product_id character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
      pv.product_value_id
      , pv.product_value_name
      , pv.value
      , pv.value2
      , pv.value3
      , pv.value_unit
      , pv.status
      , pv.type
      , pv.create_date
      , pv.last_update
      , pv.product_id
    FROM product_value pv  WHERE (
      ((pProductValueId IS NULL) OR (pv.product_value_id = pProductValueId)) AND
      ((pProductId IS NULL) OR (pv.product_id = pProductId)) AND
      ((pProductValueName IS NULL) OR (pv.product_value_name = pProductValueName)) AND
      ((pValue IS NULL) OR (pv.value = pValue)) AND
      ((pValue2 IS NULL) OR (pv.value2 = pValue2)) AND
      ((pValue3 IS NULL) OR (pv.value3 = pValue3)) AND
      ((pValueUnit IS NULL) OR (pv.value_unit = pValueUnit)) AND
      ((pStatus IS NULL) OR (pv.status = pStatus)) AND
      ((pType IS NULL) OR (pv.type = pType))
	);
END;
$$;


ALTER FUNCTION public.get_product_value(pproductvalueid character varying, pproductvaluename character varying, pvalue numeric, pvalue2 numeric, pvalue3 numeric, pvalueunit character varying, pstatus character, ptype character, pproductid character varying) OWNER TO shiwei;

--
-- Name: update_authentication(character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_authentication(pauthenticationid character varying, pauthenticationstring character varying, pauthenticationstringlower character varying, phash character varying, psalt character varying, plastlogin timestamp without time zone, plastlogout timestamp without time zone, plastchangepassword timestamp without time zone, prequestauthenticationstart timestamp without time zone, prequestauthenticationend timestamp without time zone, pauthorizationlevel integer, plastupdate timestamp without time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    oAuthenticationString varchar(32);
    oAuthenticationStringLower varchar(32);
    oHash varchar(60);
    oSalt varchar(16);
    oLastLogin timestamp without time zone;
    oLastLogout timestamp without time zone;
    oLastChangePassword timestamp without time zone;
    oRequestAuthenticationStart timestamp without time zone;
    oRequestAuthenticationEnd timestamp without time zone;
    oAuthorizationLevel integer;
    oLastUpdate timestamp without time zone;

    nAuthenticationString varchar(32);
    nAuthenticationStringLower varchar(32);
    nHash varchar(60);
    nSalt varchar(16);
    nLastLogin timestamp without time zone;
    nLastLogout timestamp without time zone;
    nLastChangePassword timestamp without time zone;
    nRequestAuthenticationStart timestamp without time zone;
    nRequestAuthenticationEnd timestamp without time zone;
    nAuthorizationLevel integer;
    nLastUpdate timestamp without time zone;
BEGIN
    -- Authentication ID is needed if not return
    IF pAuthenticationId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            a.authentication_string 
            , a.authentication_string_lower 
            , a.hash 
            , a.salt 
            , a.last_login 
            , a.last_logout
            , a.last_change_password 
            , a.request_authentication_start 
            , a.request_authentication_end 
            , a.authorization_level 
            , a.last_update 
        INTO STRICT
            oAuthenticationString
            , oAuthenticationStringLower 
            , oHash
            , oSalt
            , oLastLogin
            , oLastLogout
            , oLastChangePassword
            , oRequestAuthenticationStart
            , oRequestAuthenticationEnd
            , oAuthorizationLevel
            , oLastUpdate
        FROM authentication a WHERE 
            a.authentication_id = pAuthenticationId;


        -- Start the updating process
        IF pAuthenticationString IS NULL THEN 
            nAuthenticationString := oAuthenticationString;
        ELSEIF pAuthenticationString = '' THEN   
            -- defaulted null
            nAuthenticationString := NULL;
        ELSE
            nAuthenticationString := pAuthenticationString;
        END IF;

        IF pAuthenticationStringLower IS NULL THEN 
            nAuthenticationStringLower := oAuthenticationStringLower;
        ELSEIF pAuthenticationStringLower = '' THEN   
            -- defaulted null
            nAuthenticationStringLower := NULL;
        ELSE
            nAuthenticationStringLower := pAuthenticationStringLower;
        END IF;

        IF pHash IS NULL THEN 
            nHash := oHash;
        ELSEIF pHash = '' THEN   
            -- defaulted null
            nHash := NULL;
        ELSE
            nHash := pHash;
        END IF;

        IF pSalt IS NULL THEN 
            nSalt := oSalt;
        ELSEIF pSalt  = '' THEN   
            -- defaulted null
        ELSE
            nSalt := pSalt;
        END IF;

        IF pLastLogin IS NULL THEN 
            nLastLogin := oLastLogin;
        ELSE
            nLastLogin := pLastLogin;
        END IF;

        IF pLastLogout IS NULL THEN 
            nLastLogout := oLastLogout;
        ELSE
            nLastLogout := pLastLogout;
        END IF;

        IF pLastChangePassword IS NULL THEN 
            nLastChangePassword := oLastChangePassword;
        ELSE
            nLastChangePassword := pLastChangePassword;
        END IF;

        IF pRequestAuthenticationStart IS NULL THEN 
            nRequestAuthenticationStart := oRequestAuthenticationStart;
        ELSE
            nRequestAuthenticationStart := pRequestAuthenticationStart;
        END IF;

        IF pRequestAuthenticationEnd IS NULL THEN 
            nRequestAuthenticationEnd := oRequestAuthenticationEnd;
        ELSE
            nRequestAuthenticationEnd := pRequestAuthenticationEnd;
        END IF;

        IF pAuthorizationLevel IS NULL THEN 
            nAuthorizationLevel := oAuthorizationLevel;
        ELSE
            nAuthorizationLevel := pAuthorizationLevel;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            authentication
        SET 
            authentication_string = nAuthenticationString
            , authentication_string_lower  = nAuthenticationStringLower
            , hash  = nHash
            , salt = nSalt
            , last_login = nLastLogin
            , last_logout = nLastLogout
            , last_change_password = nLastChangePassword
            , request_authentication_start = nRequestAuthenticationStart
            , request_authentication_end = nRequestAuthenticationEnd
            , authorization_level = nAuthorizationLevel
            , last_update  = nLastUpdate
        WHERE 
            authentication_id = pAuthenticationId;
        
        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_authentication(pauthenticationid character varying, pauthenticationstring character varying, pauthenticationstringlower character varying, phash character varying, psalt character varying, plastlogin timestamp without time zone, plastlogout timestamp without time zone, plastchangepassword timestamp without time zone, prequestauthenticationstart timestamp without time zone, prequestauthenticationend timestamp without time zone, pauthorizationlevel integer, plastupdate timestamp without time zone) OWNER TO shiwei;

--
-- Name: update_configuration(character varying, character varying, text, character varying, character varying, character varying, text, character varying, character, character varying, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_configuration(pconfigurationid character varying, pname character varying, pfileurl text, pvaluehash character varying, pvalue2hash character varying, pvalue3hash character varying, pdescription text, psalt character varying, ptype character, penterpriseid character varying, plastupdate timestamp without time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    nName varchar(64);
    nFileUrl text;
    nValueHash varchar(60);
    nValue2Hash varchar(60);
    nValue3Hash varchar(60);
    nDescription text;
    nSalt varchar(16);
    nType char(1);
    nEnterpriseId varchar(32);
    nLastUpdate timestamp without time zone;

    oName varchar(64);
    oFileUrl text;
    oValueHash varchar(60);
    oValue2Hash varchar(60);
    oValue3Hash varchar(60);
    oDescription text;
    oSalt varchar(16);
    oType char(1);
    oEnterpriseId varchar(32);
    oLastUpdate timestamp without time zone;
BEGIN
    -- Configuration ID is needed if not return
    IF pConfigurationId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            c.configuration_id
            , c.name
            , c.file_url
            , c.value_hash
            , c.value2_hash
            , c.value3_hash
            , c.description
            , c.salt 
            , c.type 
            , c.enterprise_id  
            , c.last_update
        INTO STRICT
            oName
            , oFileUrl
            , oValueHash
            , oValue2Hash 
            , oValue3Hash
            , oDescription
            , oSalt
            , oType
            , oEnterpriseId 
            , oLastUpdate
        FROM configuration c WHERE 
            c.configuration_id = pConfigurationId;

        -- Start the updating process
        IF pName IS NULL THEN 
            nName := oName;
        ELSEIF pFirstName = '' THEN  
            nName := NULL;
        ELSE
            nName := pName;
        END IF;

        IF pFileUrl IS NULL THEN 
            nFileUrl := oFileUrl;
        ELSEIF pFirstFileUrl = '' THEN  
            nFileUrl := NULL;
        ELSE
            nFileUrl := pFileUrl;
        END IF;

        IF pValueHash IS NULL THEN 
            nValueHash := oValueHash;
        ELSEIF pFirstValueHash = '' THEN  
            nValueHash := NULL;
        ELSE
            nValueHash := pValueHash;
        END IF;

        IF pValue2Hash IS NULL THEN 
            nValue2Hash := oValue2Hash;
        ELSEIF pFirstValue2Hash = '' THEN  
            nValue2Hash := NULL;
        ELSE
            nValue2Hash := pValue2Hash;
        END IF;

        IF pValue3Hash IS NULL THEN 
            nValue3Hash := oValue3Hash;
        ELSEIF pFirstValue3Hash = '' THEN  
            nValue3Hash := NULL;
        ELSE
            nValue3Hash := pValue3Hash;
        END IF;

        IF pSalt IS NULL THEN 
            nSalt := oSalt;
        ELSEIF pFirstSalt = '' THEN  
            nSalt := NULL;
        ELSE
            nSalt := pSalt;
        END IF;

        IF pDescription IS NULL THEN 
            nDescription := oDescription;
        ELSEIF pFirstDescription = '' THEN  
            nDescription := NULL;
        ELSE
            nDescription := pDescription;
        END IF;

        IF pEnterpriseId IS NULL THEN 
            nEnterpriseId := oEnterpriseId;
        ELSEIF pFirstEnterpriseId = '' THEN  
            nEnterpriseId := NULL;
        ELSE
            nEnterpriseId := pEnterpriseId;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pDevice2Id = '' THEN  
            nType := NULL;
        ELSE
            nType := oType;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            configuration
        SET 
            name = nName
            , file_url = nFileUrl
            , value_hash = nValueHash
            , value2_hash = nValue2Hash
            , value3_hash = nValue3Hash
            , description = nDescription
            , salt  = nSalt
            , type  = nType
            , enterprise_id = nEnterpriseId
            , last_update = nLastUpdate
        WHERE 
            configuration_id = pConfigurationId;

        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_configuration(pconfigurationid character varying, pname character varying, pfileurl text, pvaluehash character varying, pvalue2hash character varying, pvalue3hash character varying, pdescription text, psalt character varying, ptype character, penterpriseid character varying, plastupdate timestamp without time zone) OWNER TO shiwei;

--
-- Name: update_device(character varying, character varying, character varying, character, character, character, text, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_device(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, pdescription text, plastupdate timestamp without time zone, pentityid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    nName varchar(32);
    nCode varchar(32);
    nStatus char(1);
    nType char(1);
    nType2 char(1);
    nDescription text;
    nLastUpdate timestamp without time zone;
    nEntityId varchar(32);

    oName varchar(32);
    oCode varchar(32);
    oStatus char(1);
    oType char(1);
    oType2 char(1);
    oDescription text;
    oLastUpdate timestamp without time zone;
    oEntityId varchar(32);
BEGIN
    -- ID is needed if not return
    IF pDeviceId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            d.name
            , d.code
            , d.status
            , d.type
            , d.type2
            , d.description
            , d.last_update
            , d.entity_id
        INTO STRICT
            oName
            , oCode
            , oStatus
            , oType
            , oType2
            , oDescription
            , oLastUpdate
            , oEntityId
        FROM device d WHERE 
            d.device_id = pDeviceId;

        -- Start the updating process
        IF pName IS NULL THEN 
            nName := oName;
        ELSEIF pName = '' THEN
            nName := NULL;
        ELSE
            nName := pName;
        END IF;

        IF pCode IS NULL THEN 
            nCode := oCode;
        ELSEIF pCode = '' THEN
            nCode := NULL;
        ELSE
            nCode := pCode;
        END IF;

        IF pStatus IS NULL THEN 
            nStatus := oStatus;
        ELSEIF pStatus = '' THEN
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pType = '' THEN
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pDescription IS NULL THEN
            nDescription := oDescription;
        ELSEIF pDescription = '' THEN
            nDescription := NULL;
        ELSE
            nDescription := pDescription;
        END IF;

        IF pType2 IS NULL THEN 
            nType2 := oType2;
        ELSEIF pType2 = '' THEN
            nType2 := NULL;
        ELSE
            nType2 := pType2;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        IF pEntityId IS NULL THEN 
            nEntityId := oEntityId;
        ELSEIF pEntityId = '' THEN
            nEntityId := NULL;
        ELSE
            nEntityId := pEntityId;
        END IF;


        -- start the update
        UPDATE 
            device
        SET 
            name = nName
            , code = nCode
            , status = nStatus
            , type = nType
            , type2 = nType2
            , description = nDescription
            , last_update = nLastUpdate
            , entity_id = nEntityId
        WHERE 
            device_id = pDeviceId;

        RETURN TRUE;

    END IF;
END;
$$;


ALTER FUNCTION public.update_device(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, pdescription text, plastupdate timestamp without time zone, pentityid character varying) OWNER TO shiwei;

--
-- Name: update_device(character varying, character varying, character varying, character, character, character, text, timestamp without time zone, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_device(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, pdescription text, plastupdate timestamp without time zone, pentityid character varying, pdevicevalueid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    nName varchar(32);
    nCode varchar(32);
    nStatus char(1);
    nType char(1);
    nType2 char(1);
    nDescription text;
    nLastUpdate timestamp without time zone;
    nEntityId varchar(32);
    nDeviceValueId varchar(32);

    oName varchar(32);
    oCode varchar(32);
    oStatus char(1);
    oType char(1);
    oType2 char(1);
    oDescription text;
    oLastUpdate timestamp without time zone;
    oEntityId varchar(32);
    oDeviceValueId varchar(32);
BEGIN
    -- ID is needed if not return
    IF pDeviceId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            d.name
            , d.code
            , d.status
            , d.type
            , d.type2
            , d.description
            , d.last_update
            , d.entity_id
            , d.device_value_id
        INTO STRICT
            oName
            , oCode
            , oStatus
            , oType
            , oType2
            , oDescription
            , oLastUpdate
            , oEntityId
            , oDeviceValueId
        FROM device d WHERE 
            d.device_id = pDeviceId;

        -- Start the updating process
        IF pName IS NULL THEN 
            nName := oName;
        ELSEIF pName = '' THEN
            nName := NULL;
        ELSE
            nName := pName;
        END IF;

        IF pCode IS NULL THEN 
            nCode := oCode;
        ELSEIF pCode = '' THEN
            nCode := NULL;
        ELSE
            nCode := pCode;
        END IF;

        IF pStatus IS NULL THEN 
            nStatus := oStatus;
        ELSEIF pStatus = '' THEN
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pType = '' THEN
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pDescription IS NULL THEN
            nDescription := oDescription;
        ELSEIF pDescription = '' THEN
            nDescription := NULL;
        ELSE
            nDescription := pDescription;
        END IF;

        IF pType2 IS NULL THEN 
            nType2 := oType2;
        ELSEIF pType2 = '' THEN
            nType2 := NULL;
        ELSE
            nType2 := pType2;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        IF pEntityId IS NULL THEN 
            nEntityId := oEntityId;
        ELSEIF pEntityId = '' THEN
            nEntityId := NULL;
        ELSE
            nEntityId := pEntityId;
        END IF;

        IF pDeviceValueId IS NULL THEN 
            nDeviceValueId := oDeviceValueId;
        ELSEIF pDeviceValueId = '' THEN
            nDeviceValueId := NULL;
        ELSE
            nDeviceValueId := pDeviceValueId;
        END IF;

        -- start the update
        UPDATE 
            device
        SET 
            name = nName
            , code = nCode
            , status = nStatus
            , type = nType
            , type2 = nType2
            , description = nDescription
            , last_update = nLastUpdate
            , entity_id = nEntityId
	    , device_value_id = nDeviceValueId
        WHERE 
            device_id = pDeviceId;

        RETURN TRUE;

    END IF;
END;
$$;


ALTER FUNCTION public.update_device(pdeviceid character varying, pname character varying, pcode character varying, pstatus character, ptype character, ptype2 character, pdescription text, plastupdate timestamp without time zone, pentityid character varying, pdevicevalueid character varying) OWNER TO shiwei;

--
-- Name: update_device_relationship(character varying, character varying, character varying, character varying, character varying, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_device_relationship(pdevicerelationshipid character varying, prelationshipname character varying, pdeviceid character varying, pdevice2id character varying, pentityid character varying, plastupdate timestamp without time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
     nRelationshipName varchar(64); 
     nDeviceId varchar(32); 
     nDevice2Id varchar(32);
     nEntityId varchar(32);
     nLastUpdate timestamp without time zone;

     oRelationshipName varchar(64); 
     oDeviceId varchar(32);
     oDevice2Id varchar(32);
     oEntityId varchar(32);
     oLastUpdate timestamp without time zone;
BEGIN
    -- ID is needed if not return
    IF pDeviceRelationshipId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            dr.relationship_name
            , dr.device_id 
            , dr.device_2_id
            , dr.entity_id
            , dr.last_update
        INTO STRICT
            oRelationshipName 
            , oDeviceId 
            , oDevice2Id
            , oEntityId
            , oLastUpdate
        FROM device_relationship dr WHERE
            dr.device_relationship_id = pDeviceRelationshipId;

        -- Start the updating process
        IF pRelationshipName IS NULL THEN 
            nRelationshipName := oRelationshipName;
        ELSEIF pRelationshipName = '' THEN  
            nRelationshipName := NULL;
        ELSE
            nRelationshipName := pRelationshipName;
        END IF;

        IF pDeviceId IS NULL THEN 
            nDeviceId := oDeviceId;
        ELSEIF pDeviceId = '' THEN  
            nDeviceId := NULL;
        ELSE
            nDeviceId := pDeviceId;
        END IF;

        IF pDevice2Id IS NULL THEN 
            nDevice2Id := oDevice2Id;
        ELSEIF pDevice2Id = '' THEN  
            nDevice2Id := NULL;
        ELSE
            nDevice2Id := pDevice2Id;
        END IF;

        IF pEntityId IS NULL THEN
            nEntityId := oEntityId;
        ELSEIF pEntityId = '' THEN
            nEntityId := NULL;
        ELSE
            nEntityId := pEntityId;
        END IF;

        IF pLastUpdate IS NULL THEN
            nLastUpdate := oLastUpdate;
        ELSEIF pLastUpdate = '' THEN
            nLastUpdate := NULL;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            device_relationship
        SET 
            relationship_name = nRelationshipName
            , device_id = nDeviceId
            , device_2_id = nDevice2Id
            , entity_id = nEntityId
            , last_update = nLastUpdate
        WHERE
            device_relationship_id = pDeviceRelationshipId;

        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_device_relationship(pdevicerelationshipid character varying, prelationshipname character varying, pdeviceid character varying, pdevice2id character varying, pentityid character varying, plastupdate timestamp without time zone) OWNER TO shiwei;

--
-- Name: update_device_session(character varying, character varying, character); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_device_session(pdeviceid character varying, pconnecteddeviceid character varying, pstatus character) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
     nDeviceId varchar(32); 
     nConnectedDeviceId varchar(32);
     nStatus char(1);

     oDeviceId varchar(32);
     oConnectedDeviceId varchar(32);
     oStatus char(1);
BEGIN
    -- ID is needed if not return
    IF pDeviceId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            ds.device_id 
            , ds.connected_device_id
            , ds.status
        INTO STRICT
            oDeviceId 
            , oConnectedDeviceId
            , oStatus
        FROM device_session ds WHERE
            ds.device_id = pDeviceId;

        -- Start the updating process
        IF pDeviceId IS NULL THEN 
            nDeviceId := oDeviceId;
        ELSEIF pFirstName = '' THEN  
            nDeviceId := NULL;
        ELSE
            nDeviceId := pDeviceId;
        END IF;

        IF pConnectedDeviceId IS NULL THEN 
            nConnectedDeviceId := oConnectedDeviceId;
        ELSEIF pConnectedDeviceId = '' THEN  
            nConnectedDeviceId := NULL;
        ELSE
            nConnectedDeviceId := pConnectedDeviceId;
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
            device_session
        SET 
            device_id = nDeviceId
            , connected_device_id = nConnectedDeviceId
            , status = nStatus
        WHERE
            device_id = pDeviceId;

        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_device_session(pdeviceid character varying, pconnecteddeviceid character varying, pstatus character) OWNER TO shiwei;

--
-- Name: update_device_value(character varying, character, character, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_device_value(pdevicevalueid character varying, ppush character, psms character, ptoken character varying, ptype character varying, presolution character varying, pquality character varying, phash character varying, psalt character varying, plastupdate timestamp without time zone, pdeviceid character varying, pdescription character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    nDeviceValueId varchar(32);
    nPush char(1);
    nSms char(1);
    nToken varchar(256);
    nType varchar(32);
    nResolution varchar(16);
    nQuality varchar(16);
    nHash varchar(60);
    nSalt varchar(16);
    nLastUpdate timestamp without time zone;
    nDeviceId varchar(32);
    nDescription varchar(32);

    oDeviceValueId varchar(32);
    oPush char(1);
    oSms char(1);
    oToken varchar(256);
    oType varchar(32);
    oResolution varchar(16);
    oQuality varchar(16);
    oHash varchar(60);
    oSalt varchar(16);
    oLastUpdate timestamp without time zone;
    oDeviceId varchar(32);
    oDescription varchar(32);

BEGIN
    -- ID is needed if not return
    IF pDeviceId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
          dv.push
          , dv.sms
          , dv.token
          , dv.type
          , dv.resolution
          , dv.quality
          , dv.hash
          , dv.salt
          , dv.last_update
          , dv.device_id
	  , dv.description
        INTO STRICT
          oPush
          , oSms
          , oToken
          , oType
          , oResolution
          , oQuality
          , oHash
          , oSalt
          , oLastUpdate
          , oDeviceId
	  , oDescription
        FROM device_value dv WHERE
            dv.device_value_id = pDeviceValueId or dv.device_id = pDeviceId;

        -- Start the updating process
        IF pDeviceValueId IS NULL THEN 
            nDeviceValueId := oDeviceValueId;
        ELSEIF pDeviceValueId = '' THEN
            nDeviceValueId := NULL;
        ELSE
            nDeviceValueId := pDeviceValueId;
        END IF;

        IF pPush IS NULL THEN 
            nPush := oPush;
        ELSEIF pPush = '' THEN
            nPush := NULL;
        ELSE
            nPush := pPush;
        END IF;

        IF pSms IS NULL THEN 
            nSms := oSms;
        ELSEIF pSms = '' THEN
            nSms := NULL;
        ELSE
            nSms := pSms;
        END IF;

        IF pToken IS NULL THEN 
            nToken := oToken;
        ELSEIF pToken = '' THEN
            nToken := NULL;
        ELSE
            nToken := pToken;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pType = '' THEN
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pResolution IS NULL THEN 
            nResolution := oResolution;
        ELSEIF pResolution = '' THEN
            nResolution := NULL;
        ELSE
            nResolution := pResolution;
        END IF;

        IF pQuality IS NULL THEN 
            nQuality := nQuality;
        ELSEIF pQuality = '' THEN
            nQuality := NULL;
        ELSE
            nQuality := pQuality;
        END IF;

        IF pHash IS NULL THEN
            nHash := oHash;
        ELSEIF pHash = '' THEN
            nHash := NULL;
        ELSE
            nHash := pHash;
        END IF;

        IF pSalt IS NULL THEN 
            nSalt := oSalt;
        ELSEIF pSalt = '' THEN
            nSalt := NULL;
        ELSE
            nSalt := pSalt;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        IF pDeviceId IS NULL THEN 
            nDeviceId := oDeviceId;
        ELSEIF pDeviceId = '' THEN
            nDeviceId := NULL;
        ELSE
            nDeviceId := pDeviceId;
        END IF;


        IF pDescription IS NULL THEN 
            nDescription := oDescription;
        ELSEIF pDescription = '' THEN
            nDescription := NULL;
        ELSE
            nDescription := pDescription;
        END IF;


        -- start the update
        UPDATE 
            device_value
        SET
          push = nPush
          , sms = nSms
          , token = nToken
          , type = nType
          , resolution = nResolution
          , quality = nQuality
          , hash = nHash
          , salt = nSalt
          , last_update = nLastUpdate
	  , description = nDescription
         WHERE (
          ((pDeviceId IS NULL) OR (device_id = pDeviceId)) AND
          ((device_value_id = pDeviceValueId)) -- device value ID is required
        );

        RETURN TRUE;

    END IF;
END;
$$;


ALTER FUNCTION public.update_device_value(pdevicevalueid character varying, ppush character, psms character, ptoken character varying, ptype character varying, presolution character varying, pquality character varying, phash character varying, psalt character varying, plastupdate timestamp without time zone, pdeviceid character varying, pdescription character varying) OWNER TO shiwei;

--
-- Name: update_email(character varying, character varying, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_email(pemailid character varying, pemailaddress character varying, plastupdate timestamp without time zone, pentityid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    nEmailAddress varchar(64);
    nLastUpdate timestamp without time zone;
    nEntityId varchar(32);

    oEmailAddress varchar(64);
    oLastUpdate timestamp without time zone;
    oEntityId varchar(32);
BEGIN
    -- Email ID is needed if not return
    IF pEmailId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            e.email_address
            , e.last_update
            , e.entity_id
        INTO STRICT
            oEmailAddress
            , oLastUpdate
            , oEntityId
        FROM email e WHERE 
            e.email_id = pEmailId;

        -- Start the updating process
        IF pEmailAddress IS NULL THEN 
            nEmailAddress := oEmailAddress;
        ELSEIF pFirstName = '' THEN  
            nEmailAddress := NULL;
        ELSE
            nEmailAddress := pEmailAddress;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        IF pEntityId IS NULL THEN 
            nEntityId := oEntityId;
        ELSEIF pEntityId = '' THEN  
            nEntityId := NULL;
        ELSE
            nEntityId := pEntityId;
        END IF;

        -- start the update
        UPDATE 
            email
        SET 
            email_address = nEmailAddress
            , last_update = nLastUpdate
            , entity_id = nEntityId
        WHERE 
            email_id = pEmailId;

        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_email(pemailid character varying, pemailaddress character varying, plastupdate timestamp without time zone, pentityid character varying) OWNER TO shiwei;

--
-- Name: update_enterprise(character varying, character varying, character varying, text, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_enterprise(penterpriseid character varying, pname character varying, pcode character varying, pdescription text, plastupdate timestamp without time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    nName varchar(32);
    nCode varchar(64);
    nDescription text;
    nLastUpdate timestamp without time zone;

    oName varchar(32);
    oCode varchar(64);
    oDescription text;
    oLastUpdate timestamp without time zone;
BEGIN
    -- Enterprise ID is needed if not return
    IF pEnterpriseId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
              e.name
            , e.code
            , e.description
            , e.last_update
        INTO STRICT
            oName 
            , oCode 
            , oDescription 
            , oLastUpdate 
        FROM enteprise e WHERE 
            e.enterprise_id = pEnterpriseId;

        -- Start the updating process
        IF pName IS NULL THEN 
            nName := oName;
        ELSEIF pFirstName = '' THEN  
            nName := NULL;
        ELSE
            nName := pName;
        END IF;

        IF pCode IS NULL THEN 
            nCode := oCode;
        ELSEIF pFirstCode = '' THEN  
            nCode := NULL;
        ELSE
            nCode := pCode;
        END IF;

        IF pDescription IS NULL THEN 
            nDescription := oDescription;
        ELSEIF pFirstDescription = '' THEN  
            nDescription := NULL;
        ELSE
            nDescription := pDescription;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            enteprise
        SET 
            name = nName
            , code = nCode
            , description = nDescription
            , last_update = nLastUpdate
        WHERE 
            enterprise_id = pEnterpriseId;

        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_enterprise(penterpriseid character varying, pname character varying, pcode character varying, pdescription text, plastupdate timestamp without time zone) OWNER TO shiwei;

--
-- Name: update_entity(character varying, character varying, character varying, character varying, character varying, character, boolean, character, timestamp without time zone, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_entity(pentityid character varying, pfirstname character varying, plastname character varying, pnickname character varying, pname character varying, pstatus character, papproved boolean, ptype character, plastupdate timestamp without time zone, pauthenticationid character varying, pprimaryemailid character varying, pprimaryphoneid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    oFirstName varchar(32); 
    oLastName varchar(32);
    oNickName varchar(32);
    oName varchar(64);
    oStatus char(1);
    oApproved boolean;
    oType char(1);
    oLastUpdate timestamp without time zone;
    oAuthenticationId varchar(32);
    oPrimaryEmailId varchar(32);
    oPrimaryPhoneId varchar(32);

    nFirstName varchar(32); 
    nLastName varchar(32);
    nNickName varchar(32);
    nName varchar(64);
    nStatus char(1);
    nApproved boolean;
    nType char(1);
    nLastUpdate timestamp without time zone;
    nAuthenticationId varchar(32);
    nPrimaryEmailId varchar(32);
    nPrimaryPhoneId varchar(32);
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

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pDevice2Id = '' THEN  
            nType := NULL;
        ELSE
            nType := oType;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
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

        WHERE 
            entity_id = pEntityId;
        
        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_entity(pentityid character varying, pfirstname character varying, plastname character varying, pnickname character varying, pname character varying, pstatus character, papproved boolean, ptype character, plastupdate timestamp without time zone, pauthenticationid character varying, pprimaryemailid character varying, pprimaryphoneid character varying) OWNER TO shiwei;

--
-- Name: update_log(character varying, text, character varying, character varying, text, character, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_log(plogid character varying, pmessage text, ptitle character varying, ptype character varying, plogurl text, pstatus character, pentityid character varying, pdeviceid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    oMessage text;
    oTitle varchar(32);
    oType varchar(32);
    oLogUrl text;
    oStatus char(1);
    oEntityId varchar(32);
    oDeviceId varchar(32);

    nMessage text;
    nTitle varchar(32);
    nType varchar(32);
    nLogUrl text ;
    nStatus char(1);
    nEntityId varchar(32);
    nDeviceId varchar(32);
BEGIN
    -- ID is needed if not return
    IF pLogId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            l.message 
            , l.title
            , l.type 
            , l.log_url 
            , l.status 
            , l.entity_id 
            , l.device_id 
        INTO STRICT
            oMessage
            , oTitle
            , oType
            , oLogUrl
            , oStatus
            , oEntityId
            , oDeviceId
        FROM log l WHERE 
            l.log_id = pLogId;

        -- Start the updating process
        IF pMessage IS NULL THEN 
            nMessage := oMessage;
        ELSEIF pFirstMessage = '' THEN  
            nMessage := NULL;
        ELSE
            nMessage := pMessage;
        END IF;

        IF pTitle IS NULL THEN 
            nTitle := oTitle;
        ELSEIF pDevice2Id = '' THEN  
            nTitle := NULL;
        ELSE
            nTitle := pTitle;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pType = '' THEN  
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pLogUrl IS NULL THEN 
            nLogUrl := oLogUrl;
        ELSEIF pLogUrl = '' THEN  
            nLogUrl := NULL;
        ELSE
            nLogUrl := pLogUrl;
        END IF;

        IF pStatus IS NULL THEN 
            nStatus := oStatus;
        ELSEIF pStatus = '' THEN  
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;

        IF pEntityId IS NULL THEN 
            nEntityId := oEntityId;
        ELSEIF pEntityId = '' THEN  
            nEntityId := NULL;
        ELSE
            nEntityId := pEntityId;
        END IF;

        IF pDeviceId IS NULL THEN 
            nDeviceId := oDeviceId;
        ELSEIF pDeviceId = '' THEN  
            nDeviceId := NULL;
        ELSE
            nDeviceId := pDeviceId;
        END IF;


        -- start the update
        UPDATE 
            log
        SET 
            message = nMessage
            , title = nTitle
            , type  = nType
            , log_url  = nLogUrl
            , status  = nStatus
            , entity_id = nEntityId
            , device_id = nDeviceId 
        WHERE 
            log_id = pLogId;

        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_log(plogid character varying, pmessage text, ptitle character varying, ptype character varying, plogurl text, pstatus character, pentityid character varying, pdeviceid character varying) OWNER TO shiwei;

--
-- Name: update_media(character varying, character varying, character, text, text, character, text, character varying, text, text, text, text, character varying, character varying, numeric); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_media(pmediaid character varying, ptitle character varying, ptype character, pfilename text, pmediaurl text, pstatus character, pdescription text, pfiletype character varying, pimgurl text, pimgurl2 text, pimgurl3 text, pimgurl4 text, pdeviceid character varying, pentityid character varying, pfilesize numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    oTitle varchar(32);
    oType char(1);
    oFilename text;
    oMediaUrl text; 
    oStatus char(1);
    oDescription text;
    oFileType varchar(16);
    oImgUrl text;
    oImgUrl2 text;
    oImgUrl3 text;
    oImgUrl4 text;
    oDeviceId varchar(32);
    oEntityId varchar(32);
    oFileSize decimal;

    nTitle varchar(32);
    nType char(1);
    nFilename text;
    nMediaUrl text;
    nStatus char(1);
    nDescription text;
    nFileType varchar(16);
    nImgUrl text;
    nImgUrl2 text;
    nImgUrl3 text;
    nImgUrl4 text;
    nDeviceId varchar(32);
    nEntityId varchar(32);
    nFileSize decimal;
BEGIN
    -- ID is needed if not return
    IF pMediaId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            m.title
            , m.type 
            , m.filename
            , m.media_url 
            , m.status
	    , m.description
	    , m.file_type
	    , m.img_url
	    , m.img_url2
	    , m.img_url3
	    , m.img_url4
	    , m.device_id
	    , m.entity_id
	    , m.filesize
        INTO STRICT
            oTitle
            , oType
            , oFilename
            , oMediaUrl
            , oStatus
	    , oDescription
	    , oFileType
	    , oImgUrl
	    , oImgUrl2
	    , oImgUrl3
	    , oImgUrl4
            , oDeviceId
            , oEntityId
            , oFileSize
        FROM media m WHERE 
            m.media_id = pMediaId;

        -- Start the updating process
        IF pTitle IS NULL THEN 
            nTitle := oTitle;
        ELSEIF pTitle = '' THEN  
            nTitle := NULL;
        ELSE
            nTitle := pTitle;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pType = '' THEN  
            nType := NULL;
        ELSE
            nType := pType;
        END IF;

        IF pFilename IS NULL THEN 
            nFilename := oFilename;
        ELSEIF pFilename = '' THEN  
            nFilename := NULL;
        ELSE
            nFilename := pFilename;
        END IF;

        IF pMediaUrl IS NULL THEN 
            nMediaUrl := oMediaUrl;
        ELSEIF pMediaUrl = '' THEN  
            nMediaUrl := NULL;
        ELSE
            nMediaUrl := pMediaUrl;
        END IF;

        IF pStatus IS NULL THEN 
            nStatus := oStatus;
        ELSEIF pStatus = '' THEN  
            nStatus := NULL;
        ELSE
            nStatus := pStatus;
        END IF;

        IF pDescription IS NULL THEN
            nDescription := oDescription;
        ELSEIF pDescription = '' THEN
            nDescription := NULL;
        ELSE
            nDescription := pDescription;
        END IF;

        IF pFileType IS NULL THEN
            nFileType := oFileType;
        ELSEIF pFileType = '' THEN
            nFileType := NULL;
        ELSE
            nFileType := pFileType;
        END IF;

        IF pImgUrl IS NULL THEN
            nImgUrl := oImgUrl;
        ELSEIF pImgUrl = '' THEN
            nImgUrl := NULL;
        ELSE
            nImgUrl := pImgUrl;
        END IF;

        IF pImgUrl2 IS NULL THEN
            nImgUrl2 := oImgUrl2;
        ELSEIF pImgUrl2 = '' THEN
            nImgUrl2 := NULL;
        ELSE
            nImgUrl2 := pImgUrl2;
        END IF;

        IF pImgUrl3 IS NULL THEN
            nImgUrl3 := oImgUrl3;
        ELSEIF pImgUrl3 = '' THEN
            nImgUrl3 := NULL;
        ELSE
            nImgUrl3 := pImgUrl3;
        END IF;

        IF pImgUrl4 IS NULL THEN
            nImgUrl4 := oImgUrl4;
        ELSEIF pImgUrl4 = '' THEN
            nImgUrl4 := NULL;
        ELSE
            nImgUrl4 := pImgUrl4;
        END IF;

        IF pDeviceId IS NULL THEN 
            nDeviceId := oDeviceId;
        ELSEIF pDeviceId = '' THEN  
            nDeviceId := NULL;
        ELSE
            nDeviceId := pDeviceId;
        END IF;

        IF pEntityId IS NULL THEN 
            nEntityId := oEntityId;
        ELSEIF pEntityId = '' THEN  
            nEntityId := NULL;
        ELSE
            nEntityId := pEntityId;
        END IF;

        IF pFileSize IS NULL THEN 
            nFileSize := oFileSize;
        ELSEIF pFileSize = '' THEN  
            nFileSize := NULL;
        ELSE
            nFileSize := pFileSize;
        END IF;

        -- start the update
        UPDATE 
            media
        SET 
            title = pTitle
            , type = pType
            , filename = pFileName
            , media_url = pMediaUrl
            , status = pStatus
            , description = pDescription
            , file_type = pFileType
            , img_url = pImgUrl
            , img_url2 = pImgUrl2
            , img_url3 = pImgUrl3
            , img_url4 = pImgUrl4
            , device_id = pDeviceId
            , entity_id = pEntityId
            , filesize = pFileSize
        WHERE 
            media_id = pMediaId;

        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_media(pmediaid character varying, ptitle character varying, ptype character, pfilename text, pmediaurl text, pstatus character, pdescription text, pfiletype character varying, pimgurl text, pimgurl2 text, pimgurl3 text, pimgurl4 text, pdeviceid character varying, pentityid character varying, pfilesize numeric) OWNER TO shiwei;

--
-- Name: update_message(character varying, text, character, timestamp without time zone, character varying, character); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_message(pmessageid character varying, pmessage text, ptype character, plastupdate timestamp without time zone, pownerid character varying, ptriggerevent character) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    nMessage text;
    nType char(1);
    nLastUpdate timestamp without time zone;
    nOwnerId varchar(32);
    nTriggerEvent char(2);

    oMessage text;
    oType char(1);
    oLastUpdate timestamp without time zone;
    oOwnerId varchar(32);
    oTriggerEvent char(2);
BEGIN
    -- Message ID is needed if not return
    IF pMessageId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            e.message
            , e.type
            , e.last_update
            , e.owner_id
            , e.trigger_event
        INTO STRICT
            oMessage
            , oType
            , oLastUpdate
            , oOwnerId
            , oTriggerEvent
        FROM message e WHERE 
            e.message_id = pMessageId;

        -- Start the updating process
        IF pMessage IS NULL THEN 
            nMessage := oMessage;
        ELSEIF pMessage = '' THEN  
            nMessage := NULL;
        ELSE
            nMessage := pMessage;
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

        IF pOwnerId IS NULL THEN 
            nOwnerId := oOwnerId;
        ELSEIF pOwnerId = '' THEN  
            nOwnerId := NULL;
        ELSE
            nOwnerId := pOwnerId;
        END IF;

        IF pTriggerEvent IS NULL THEN 
            nTriggerEvent := oTriggerEvent;
        ELSEIF pTriggerEvent = '' THEN  
            nTriggerEvent := NULL;
        ELSE
            nTriggerEvent := pTriggerEvent;
        END IF;

        -- start the update
        UPDATE 
            message
        SET 
            message = nMessage
            , type = nType
            , last_update = nLastUpdate
            , owner_id = nOwnerId
            , trigger_event = nTriggerEvent
        WHERE 
            message_id = pMessageId;

        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_message(pmessageid character varying, pmessage text, ptype character, plastupdate timestamp without time zone, pownerid character varying, ptriggerevent character) OWNER TO shiwei;

--
-- Name: update_phone(character varying, character varying, character varying, character varying, character varying, timestamp without time zone, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_phone(pphoneid character varying, pphonedigits character varying, pdigits character varying, pcountrycode character varying, pcode character varying, plastupdate timestamp without time zone, pentityid character varying, pdeviceid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    nPhoneDigits varchar(32); 
    nDigits varchar(32);
    nCountryCode varchar(4);
    nCode varchar(8);
    nLastUpdate timestamp without time zone;
    nEntityId varchar(32);
    nDeviceId varchar(32);

    oPhoneDigits varchar(32); 
    oDigits varchar(32);
    oCountryCode varchar(4);
    oCode varchar(8);
    oLastUpdate timestamp without time zone;
    oEntityId varchar(32);
    oDeviceId varchar(32);
BEGIN
    -- Phone ID is needed if not return
    IF pPhoneId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            p.phone_digits
            , p.digits
            , p.country_code
            , p.code
            , p.last_update
            , p.entity_id
            , p.device_id
        INTO STRICT
            oPhoneDigits
            , oDigits
            , oCountryCode
            , oCode
            , oLastUpdate
            , oEntityId
            , oDeviceId
        FROM phone p WHERE 
            p.phone_id = pPhoneId;

        -- Start the updating process
        IF pPhoneDigits IS NULL THEN 
            nPhoneDigits := oPhoneDigits;
        ELSEIF pPhoneDigits = '' THEN
            nPhoneDigits := NULL;
        ELSE
            nPhoneDigits := pPhoneDigits;
        END IF;
        
        IF pDigits IS NULL THEN
            nDigits := oDigits;
        ELSEIF pDigits = '' THEN
            nDigits := NULL;
        ELSE
            nDigits := pDigits;
        END IF;

        IF pCountryCode IS NULL THEN 
            nCountryCode := oCountryCode;
        ELSEIF pCountryCode = '' THEN  
            nCountryCode := NULL;
        ELSE
            nCountryCode := pCountryCode;
        END IF;

        IF pCode IS NULL THEN 
            nCode := oCode;
        ELSEIF pCode = '' THEN  
            nCode := NULL;
        ELSE
            nCode := pCode;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        IF pEntityId IS NULL THEN 
            nEntityId := oEntityId;
        ELSEIF pEntityId = '' THEN  
            nEntityId := NULL;
        ELSE
            nEntityId := pEntityId;
        END IF;

        IF pDeviceId IS NULL THEN 
            nDeviceId := oDeviceId;
        ELSEIF pEntityId = '' THEN  
            nDeviceId := NULL;
        ELSE
            nDeviceId := pDeviceId;
        END IF;

        -- start the update
        UPDATE 
            phone
        SET 
            phone_digits = nPhoneDigits
            , digits = nDigits
            , country_code = nCountryCode
            , code = nCode
            , last_update = nLastUpdate
            , entity_id = nEntityId
            , device_id = nDeviceId
        WHERE 
            phone_id = pPhoneId;

        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_phone(pphoneid character varying, pphonedigits character varying, pdigits character varying, pcountrycode character varying, pcode character varying, plastupdate timestamp without time zone, pentityid character varying, pdeviceid character varying) OWNER TO shiwei;

--
-- Name: update_product(character varying, character varying, text, character, character, character varying, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_product(pproductid character varying, pname character varying, pdescription text, pstatus character, ptype character, pcode character varying, plastupdate timestamp without time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    oName varchar(32);
    oDescription text;
    oStatus char(1);
    oType char(1);
    oCode varchar(60);
    oLastUpdate timestamp without time zone;

    nName varchar(32); 
    nDescription text;
    nStatus char(1);
    nType char(1);
    nCode varchar(60);
    nLastUpdate timestamp without time zone;
BEGIN
    -- ID is needed if not return
    IF pProductId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            p.name
            , p.description
            , p.status
            , p.type
            , p.code
            , p.last_update
        INTO STRICT
            oName
            , oDescription
            , oStatus
            , oType
            , oCode
            , oLastUpdate
        FROM product p WHERE 
            p.product_id = pProductId;

        -- Start the updating process
        IF pName IS NULL THEN 
            nName := oName;
        ELSEIF pDevice2Id = '' THEN  
            nName := NULL;
        ELSE
            nName := pName;
        END IF;

        IF pDescription IS NULL THEN 
            nDescription := oDescription;
        ELSEIF pDevice2Id = '' THEN  
            nDescription := NULL;
        ELSE
            nDescription := oDescription;
        END IF;

        IF pStatus IS NULL THEN 
            nStatus := oStatus;
        ELSEIF pDevice2Id = '' THEN  
            nStatus := NULL;
        ELSE
            nStatus := oStatus;
        END IF;

        IF pType IS NULL THEN 
            nType := oType;
        ELSEIF pDevice2Id = '' THEN  
            nType := NULL;
        ELSE
            nType := oType;
        END IF;
        
        IF pCode IS NULL THEN
            nCode := oCode;
        ELSEIF pDevice2Id = '' THEN
            nCode := NULL;
        ELSE
            nCode := oCode;
        END IF;

        IF pLastUpdate IS NULL THEN 
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;

        -- start the update
        UPDATE 
            product
        SET 
            name = nName
            , description = nDescription
            , status = nStatus
            , type = nType
            , last_update = nLastUpdate
        WHERE 
            product_id = pProductId;

        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_product(pproductid character varying, pname character varying, pdescription text, pstatus character, ptype character, pcode character varying, plastupdate timestamp without time zone) OWNER TO shiwei;

--
-- Name: update_product_registration(character varying, character, character, timestamp without time zone, character varying, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_product_registration(pproductregistrationid character varying, pstatus character, ptype character, plastupdate timestamp without time zone, pproductid character varying, pentityid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    oStatus char(1);
    oType char(1);
    oLastUpdate timestamp without time zone;
    oProductId varchar(32);
    oEntityId varchar(32);

    nStatus char(1);
    nType char(1);
    nLastUpdate timestamp without time zone;
    nProductId varchar(32);
    nEntityId varchar(32);
BEGIN
    -- ID is needed if not return
    IF pProductId IS NULL THEN  
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
            pr.status
            , pr.type
            , pr.create_date
            , pr.product_id
            , pr.entity_id
        INTO STRICT
            oStatus
            , oType
            , oLastUpdate
            , oProductId
            , oEntityId
        FROM product_registration pr WHERE 
            pr.product_registration_id = pProductRegistrationId;

        -- Start the updating process
        IF pStatus IS NULL THEN 
            nStatus := oStatus;
        ELSEIF pDevice2Id = '' THEN  
            nStatus := NULL;
        ELSE
            nStatus := oStatus;
        END IF;
        
        IF pType IS NULL THEN
            nType := oType;
        ELSEIF pDevice2Id = '' THEN
            nType := NULL;
        ELSE
            nType := oType;
        END IF;

        IF pLastUpdate IS NULL THEN
            nLastUpdate := oLastUpdate;
        ELSEIF pDevice2Id = '' THEN
            nLastUpdate := NULL;
        ELSE
            nLastUpdate := oLastUpdate;
        END IF;

        IF pProductId IS NULL THEN 
            nProductId := oProductId;
        ELSEIF pDevice2Id = '' THEN  
            nProductId := NULL;
        ELSE
            nProductId := oProductId;
        END IF;

        IF pEntityId IS NULL THEN 
            nEntityId := oEntityId;
        ELSEIF pDevice2Id = '' THEN  
            nEntityId := NULL;
        ELSE
            nEntityId := oEntityId;
        END IF;

		-- start the update
        UPDATE 
            product_registration
        SET 
            status = nStatus
            , product_id = nProduct_Id
            , entity_id = nEntity_Id

        WHERE 
            product_registration_id = pProductRegistrationId;
            
        RETURN TRUE;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_product_registration(pproductregistrationid character varying, pstatus character, ptype character, plastupdate timestamp without time zone, pproductid character varying, pentityid character varying) OWNER TO shiwei;

--
-- Name: update_product_value(character varying, character varying, numeric, numeric, numeric, character varying, character, character, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: shiwei
--

CREATE FUNCTION update_product_value(pproductvalueid character varying, pproductvaluename character varying, pvalue numeric, pvalue2 numeric, pvalue3 numeric, pvalueunit character varying, pstatus character, ptype character, plastupdate timestamp without time zone, pproductid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
  DECLARE
     oProductValueName varchar(256);
     oValue decimal;
     oValue2 decimal;
     oValue3 decimal;
     oValueUnit varchar(32);
     oStatus char(1);
     oType char(1);
     oLastUpdate timestamp without time zone;
     oProductId varchar(32);

     nProductValueName varchar(256);
     nValue decimal;
     nValue2 decimal;
     nValue3 decimal;
     nValueUnit varchar(32);
     nStatus char(1);
     nType char(1);
     nLastUpdate timestamp without time zone;
     nProductId varchar(32);
  BEGIN
      -- ID is needed if not return
      IF pProductValueId IS NULL THEN
          RETURN FALSE;
      ELSE
          -- select the variables into the old variables
          SELECT
            pv.product_value_name
            , pv.value
            , pv.value2
            , pv.value3
            , pv.value_unit
            , pv.status
            , pv.type
            , pv.last_update
            , pv.product_id
          INTO STRICT
             oProductValueName
             , oValue
             , oValue2
             , oValue3
             , oValueUnit
             , oStatus
             , oType
             , oLastUpdate
             , oProductId
          FROM product_value pv WHERE
              p.product_value_id = pProductValueId;

          -- Start the updating process
          IF pProductValueName IS NULL THEN
              nProductValueName := oProductValueName;
          ELSEIF pDevice2Id = '' THEN
              nProductValueName := NULL;
          ELSE
              nProductValueName := pProductValueName;
          END IF;

          IF pValue IS NULL THEN
              nValue := oValue;
          ELSEIF pDevice2Id = '' THEN
              nValue := NULL;
          ELSE
              nValue := oValue;
          END IF;
          
          IF pValue2 IS NULL THEN
              nValue2 := oValue2;
          ELSEIF pDevice2Id = '' THEN
              nValue2 := NULL;
          ELSE
              nValue2 := oValue2;
          END IF;

          IF pValue3 IS NULL THEN
              nValue3 := oValue3;
          ELSEIF pDevice3Id = '' THEN
              nValue3 := NULL;
          ELSE
              nValue3 := oValue3;
          END IF;

          IF pValueUnit IS NULL THEN
              nValueUnit := oValueUnit;
          ELSEIF pDevice3Id = '' THEN
              nValueUnit := NULL;
          ELSE
              nValueUnit := oValueUnit;
          END IF;

          IF pStatus IS NULL THEN
              nStatus := oStatus;
          ELSEIF pDevice2Id = '' THEN
              nStatus := NULL;
          ELSE
              nStatus := oStatus;
          END IF;

          IF pType IS NULL THEN
              nType := oType;
          ELSEIF pDevice2Id = '' THEN
              nType := NULL;
          ELSE
              nType := oType;
          END IF;

          IF pLastUpdate IS NULL THEN
              nLastUpdate := oLastUpdate;
          ELSE
              nLastUpdate := pLastUpdate;
          END IF;

          IF pProductId IS NULL THEN
              nProductId := oProductId;
          ELSE
              nProductId := pProductId;
          END IF;

          -- start the update
          UPDATE
              product
          SET
            product_value_name = nProductValueName
            , value = nValue
            , value2 = nValue2
            , value3 = nValue3
            , value_unit = nValueUnit
            , status = nStatus
            , type = nType
            , last_update = nLastUpdate
            , product_id = nProductId
          WHERE
              product_value_id = pProductValueId;

          RETURN TRUE;

      END IF;
  END;
  $$;


ALTER FUNCTION public.update_product_value(pproductvalueid character varying, pproductvaluename character varying, pvalue numeric, pvalue2 numeric, pvalue3 numeric, pvalueunit character varying, pstatus character, ptype character, plastupdate timestamp without time zone, pproductid character varying) OWNER TO shiwei;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: address; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE address (
    address_id character varying(32) NOT NULL,
    apartment character varying(64),
    road_name text,
    road_name2 text,
    suite character varying(32),
    zip character varying(16),
    country character varying(128),
    province character varying(128),
    state character varying(128),
    city character varying(128),
    type character(1),
    status character(1),
    longitude numeric,
    latitude numeric,
    create_date timestamp without time zone,
    last_update timestamp without time zone
);


ALTER TABLE public.address OWNER TO shiwei;

--
-- Name: authentication; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE authentication (
    authentication_id character varying(32) NOT NULL,
    authentication_string character varying(64),
    authentication_string_lower character varying(64),
    hash character varying(60),
    salt character varying(16),
    last_login timestamp without time zone,
    last_logout timestamp without time zone,
    last_change_password timestamp without time zone,
    create_date timestamp without time zone,
    last_update timestamp without time zone,
    request_authentication_start timestamp without time zone,
    request_authentication_end timestamp without time zone,
    authorization_level integer DEFAULT 100
);


ALTER TABLE public.authentication OWNER TO shiwei;

--
-- Name: configuration; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE configuration (
    configuration_id character varying(32) NOT NULL,
    name character varying(64),
    file_url text,
    value_hash character varying(60),
    value2_hash character varying(60),
    value3_hash character varying(60),
    description text,
    salt character varying(16),
    type character(1),
    enterprise_id character varying(32),
    create_date timestamp without time zone,
    last_update timestamp without time zone
);


ALTER TABLE public.configuration OWNER TO shiwei;

--
-- Name: device; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE device (
    device_id character varying(32) NOT NULL,
    name character varying(32),
    code character varying(32),
    status character(1),
    type character(1),
    type2 character(1),
    create_date timestamp without time zone,
    last_update timestamp without time zone,
    entity_id character varying(32),
    description text
);


ALTER TABLE public.device OWNER TO shiwei;

--
-- Name: device_relationship; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE device_relationship (
    device_relationship_id character varying(32) NOT NULL,
    device_id character varying(32),
    device_2_id character varying(32),
    create_date timestamp without time zone,
    entity_id character varying(32),
    last_update timestamp without time zone,
    relationship_name character varying(64)
);


ALTER TABLE public.device_relationship OWNER TO shiwei;

--
-- Name: device_session; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE device_session (
    device_id character varying(32),
    connected_device_id character varying(32),
    status character(1),
    create_date timestamp without time zone
);


ALTER TABLE public.device_session OWNER TO shiwei;

--
-- Name: device_value; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE device_value (
    device_value_id character varying(32) NOT NULL,
    push character(1),
    sms character(1),
    token character varying(256),
    resolution character varying(16),
    hash character varying(60),
    salt character varying(16),
    create_date timestamp without time zone,
    last_update timestamp without time zone,
    device_id character varying(32),
    description text,
    quality character varying(16),
    type character varying(32)
);


ALTER TABLE public.device_value OWNER TO shiwei;

--
-- Name: email; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE email (
    email_id character varying(32) NOT NULL,
    email_address character varying(64),
    create_date timestamp without time zone,
    last_update timestamp without time zone,
    entity_id character varying(32)
);


ALTER TABLE public.email OWNER TO shiwei;

--
-- Name: enterprise; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE enterprise (
    enterprise_id character varying(32) NOT NULL,
    name character varying(32),
    code character varying(64),
    description text,
    create_date timestamp without time zone,
    last_update timestamp without time zone
);


ALTER TABLE public.enterprise OWNER TO shiwei;

--
-- Name: entity; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE entity (
    entity_id character varying(32) NOT NULL,
    first_name character varying(32),
    last_name character varying(32),
    nick_name character varying(32),
    name character varying(64),
    status character(1),
    approved boolean,
    type character(1),
    create_date timestamp without time zone,
    last_update timestamp without time zone,
    authentication_id character varying(32),
    primary_email_id character varying(32),
    primary_phone_id character varying(32)
);


ALTER TABLE public.entity OWNER TO shiwei;

--
-- Name: log; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE log (
    log_id character varying(32) NOT NULL,
    message text,
    title character varying(32),
    type character varying(32),
    log_url text,
    status character(1),
    create_date timestamp without time zone,
    entity_id character varying(32),
    device_id character varying(32)
);


ALTER TABLE public.log OWNER TO shiwei;

--
-- Name: media; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE media (
    media_id character varying(32) NOT NULL,
    title character varying(32),
    type character(1),
    filename text,
    media_url text,
    status character(1),
    create_date timestamp without time zone,
    device_id character varying(32),
    description text,
    file_type character varying(16),
    img_url text,
    img_url2 text,
    img_url3 text,
    img_url4 text,
    entity_id character varying(32),
    filesize numeric
);


ALTER TABLE public.media OWNER TO shiwei;

--
-- Name: message; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE message (
    message_id character varying(32) NOT NULL,
    message text,
    type character(1),
    create_date timestamp without time zone,
    last_update timestamp without time zone,
    owner_id character varying(32),
    trigger_event character(2)
);


ALTER TABLE public.message OWNER TO shiwei;

--
-- Name: module; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE module (
    module_id character varying(32) NOT NULL,
    name character varying(64),
    slug character varying(32),
    status character(1),
    create_date timestamp without time zone
);


ALTER TABLE public.module OWNER TO shiwei;

--
-- Name: module_registration; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE module_registration (
    module_registration_id character varying(32) NOT NULL,
    module_id character varying(32),
    enterprise_id character varying(32),
    status character(1),
    create_date timestamp without time zone
);


ALTER TABLE public.module_registration OWNER TO shiwei;

--
-- Name: phone; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE phone (
    phone_id character varying(32) NOT NULL,
    phone_digits character varying(32),
    country_code character varying(4),
    code character varying(8),
    create_date timestamp without time zone,
    last_update timestamp without time zone,
    entity_id character varying(32),
    device_id character varying(32),
    digits character varying(32)
);


ALTER TABLE public.phone OWNER TO shiwei;

--
-- Name: product; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE product (
    product_id character varying(32) NOT NULL,
    name character varying(32),
    description text,
    type character(1),
    status character(1),
    create_date timestamp without time zone,
    last_update timestamp without time zone,
    code character varying(60)
);


ALTER TABLE public.product OWNER TO shiwei;

--
-- Name: product_registration; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE product_registration (
    product_registration_id character varying(32) NOT NULL,
    status character(1),
    type character(1),
    product_id character varying(32),
    entity_id character varying(32),
    create_date timestamp without time zone,
    last_update timestamp without time zone
);


ALTER TABLE public.product_registration OWNER TO shiwei;

--
-- Name: product_value; Type: TABLE; Schema: public; Owner: shiwei; Tablespace: 
--

CREATE TABLE product_value (
    product_value_id character varying(32) NOT NULL,
    product_value_name character varying(256),
    value numeric,
    value2 numeric,
    value3 numeric,
    value_unit character varying(32),
    status character(1),
    type character(1),
    create_date timestamp without time zone,
    last_update timestamp without time zone,
    product_id character varying(32)
);


ALTER TABLE public.product_value OWNER TO shiwei;

--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: shiwei
--



--
-- Data for Name: authentication; Type: TABLE DATA; Schema: public; Owner: shiwei
--

INSERT INTO authentication VALUES ('L5A539ZI-A3NZMQJC-4TC06EAR', 'shiwei@lifeopp.com', 'shiwei@lifeopp.com', '$2y$10$ykBIBitbYoa1aRl/oSJQo.xIUbOy4ycanyFZr6/2Vo7ZnmJ4Wd0xi', NULL, '2014-01-18 13:55:09', '2014-01-18 13:55:27', '2014-01-18 13:55:09', '2013-10-27 06:15:30', '2014-01-18 13:55:27', NULL, NULL, 100);
INSERT INTO authentication VALUES ('WS6YR8SY-YI16WQ2F-KIN3HW10', 'eamon@eyeorcas.com', 'eamon@eyeorcas.com', '$2y$10$VU9sv7P9lJE/8PsEqRpdqued3CjT0TLFuh6nvqlthmCyOGjGol1V6', NULL, '2014-01-18 13:55:45', '2014-01-18 13:55:48', '2014-01-18 13:55:45', '2013-11-18 13:30:49', '2014-01-18 13:55:48', NULL, NULL, 100);
INSERT INTO authentication VALUES ('AON2RRUL-P5KEPL7X-TAK4NZ1G', 'shiweifong@gmail.com', 'shiweifong@gmail.com', '$2y$10$tne11bOuUBLehBmts.bO4Ow6Id82dAAT.qMQLiD.BnxBnzoudS5xe', NULL, '2014-01-18 13:58:30', '2014-01-18 13:54:38', '2014-01-18 09:49:49', '2013-10-27 06:10:51', '2014-01-18 13:58:30', NULL, NULL, 500);
INSERT INTO authentication VALUES ('OF8MUPGU-TXI4IO3R-F3GOJPA6', 'xmm@gmail.com', 'xmm@gmail.com', NULL, NULL, NULL, NULL, NULL, '2013-12-28 05:45:02', NULL, NULL, NULL, NULL);
INSERT INTO authentication VALUES ('YADEU5AY-DM93A3RY-QCQ2IQPK', 'shiyuan@eyeorcas.com', 'shiyuan@eyeorcas.com', '$2y$10$rUr6PDwa8SUNE.kX5ym1u.VKuFkJ4ZTlHthRm4Hj7QjMYGHpsxvba', NULL, '2014-01-18 07:42:33', '2014-01-18 08:24:00', '2014-01-18 07:42:33', '2013-11-19 07:49:50', '2014-01-18 08:24:00', NULL, NULL, 100);
INSERT INTO authentication VALUES ('AMP8QLLA-TMULTIEQ-FLPUTQSH', 'yewesther66@gmail.com', 'yewesther66@gmail.com', '$2y$10$sjxwVm3wHU.tCFeHejMwgeUvjPgX6kmSJajDAPQEQ0PGArIoff2Zy', NULL, '2014-01-18 08:46:14', '2014-01-18 08:47:40', '2014-01-18 08:46:14', '2014-01-18 08:25:14', '2014-01-18 08:47:40', NULL, NULL, 100);


--
-- Data for Name: configuration; Type: TABLE DATA; Schema: public; Owner: shiwei
--



--
-- Data for Name: device; Type: TABLE DATA; Schema: public; Owner: shiwei
--

INSERT INTO device VALUES ('MDZM5UFT-M5YRN0UY-AL0B6OQB', 'Cety HXS', 'CETYHXS', 'V', 'H', 'S', '2013-11-26 11:17:22', '2013-11-26 14:31:30', 'BUFXDN30-YLTMME29-HALX5YR1', NULL);
INSERT INTO device VALUES ('3BMSRNAS-7NOSQTX0-64J4WZOD', 'Singapore''s HXS', 'SGHXS123', 'V', 'H', 'S', '2013-12-21 11:13:31', '2013-12-23 09:37:14', 'BUFXDN30-YLTMME29-HALX5YR1', NULL);
INSERT INTO device VALUES ('2KROTT2J-NUWZW3C4-CH1REK15', 'Test HXS 2', 'TESTHXS2', 'V', 'H', 'S', '2013-12-23 15:04:43', NULL, 'BUFXDN30-YLTMME29-HALX5YR1', NULL);
INSERT INTO device VALUES ('FF1234', 'Master Bedroom HXS', 'MASTERBEDHXS', 'V', 'H', 'S', '2013-11-17 05:31:33', '2013-12-28 05:26:44', 'BUFXDN30-YLTMME29-HALX5YR1', NULL);
INSERT INTO device VALUES ('A5KINOS4-IOHH7KRR-KC7RZGUM', 'Bathroom HXS', 'BATHXS', 'V', 'H', 'S', '2013-11-17 14:22:05', '2013-12-29 02:04:50', 'BUFXDN30-YLTMME29-HALX5YR1', NULL);
INSERT INTO device VALUES ('FDBXULF7-B1LSR9L1-PCLR3XBB', 'Balcony HXS', 'BALHXS', 'V', 'H', 'S', '2013-11-17 05:32:22', '2013-12-30 03:02:10', 'BUFXDN30-YLTMME29-HALX5YR1', NULL);
INSERT INTO device VALUES ('577HSAAD-02Y2O4WW-BKDPXZ2U', 'LifeOpp''s HXS 123', 'LOHXS123', 'V', 'H', 'S', '2014-01-02 03:01:29', '2014-01-08 10:16:32', 'BUFXDN30-YLTMME29-HALX5YR1', NULL);
INSERT INTO device VALUES ('6RZARBQZ-3ZQE3DQX-9LYDJ823', 'Computer Room HXS 123', 'COMP123', 'V', 'H', 'S', '2013-11-17 05:31:56', '2014-01-08 10:16:41', 'BUFXDN30-YLTMME29-HALX5YR1', NULL);
INSERT INTO device VALUES ('O2RJ95PR-SH0DE9GD-O7F7PJRT', 'Bathroom HXS', 'BATH', 'V', 'H', 'S', '2014-01-08 10:23:06', NULL, 'BUFXDN30-YLTMME29-HALX5YR1', NULL);
INSERT INTO device VALUES ('IQFPZHHE-KXKGG8IT-64NYTUUT', 'Living Room HXS', 'LRHXS', 'V', 'H', 'S', '2014-01-08 10:23:18', NULL, 'BUFXDN30-YLTMME29-HALX5YR1', NULL);
INSERT INTO device VALUES ('Z578OEQB-QRZN9HR9-S8GKH9WL', 'Kitchen HXS', 'KITHXS', 'V', 'H', 'S', '2014-01-08 10:23:31', NULL, 'BUFXDN30-YLTMME29-HALX5YR1', NULL);
INSERT INTO device VALUES ('4OOKBH83-BHYTR4CX-Y5CWIZFU', 'Kitchen EyeMicro', 'KITMICRO', 'V', 'M', 'S', '2014-01-16 14:44:40', NULL, 'BUFXDN30-YLTMME29-HALX5YR1', NULL);
INSERT INTO device VALUES ('G422PTFQ-HY1319TM-27AIRJCB', 'LifeOpp''s Eye Micro', 'LOEYEMICRO', 'V', 'M', 'S', '2014-01-16 14:46:22', NULL, 'BUFXDN30-YLTMME29-HALX5YR1', NULL);


--
-- Data for Name: device_relationship; Type: TABLE DATA; Schema: public; Owner: shiwei
--

INSERT INTO device_relationship VALUES ('UZAWJDMR-R66AQ7W1-7S93DTA2', '6RZARBQZ-3ZQE3DQX-9LYDJ823', NULL, '2013-11-17 05:31:56', 'BUFXDN30-YLTMME29-HALX5YR1', NULL, NULL);
INSERT INTO device_relationship VALUES ('K2T7IM9E-M2WJUUGY-N75G1MOF', '577HSAAD-02Y2O4WW-BKDPXZ2U', NULL, '2014-01-02 03:01:29', 'BUFXDN30-YLTMME29-HALX5YR1', NULL, NULL);
INSERT INTO device_relationship VALUES ('U6SWSS9Z-QHUWU4K7-X1W142QZ', 'YND262IM-RG7WXMEG-DZJECAMB', NULL, '2014-01-02 03:03:41', 'S4M1BTXL-9QLSE54R-XYF3JF2T', NULL, NULL);
INSERT INTO device_relationship VALUES ('Y4BEEFZE-YL2FOUGG-7XIYMZ2U', 'O2RJ95PR-SH0DE9GD-O7F7PJRT', NULL, '2014-01-08 10:23:06', 'BUFXDN30-YLTMME29-HALX5YR1', NULL, NULL);
INSERT INTO device_relationship VALUES ('RIMDCQM4-89RTHAXH-PJDJ091Y', 'IQFPZHHE-KXKGG8IT-64NYTUUT', NULL, '2014-01-08 10:23:18', 'BUFXDN30-YLTMME29-HALX5YR1', NULL, NULL);
INSERT INTO device_relationship VALUES ('Q3J8U39K-FTTUKH20-UUCHF3GA', 'Z578OEQB-QRZN9HR9-S8GKH9WL', NULL, '2014-01-08 10:23:32', 'BUFXDN30-YLTMME29-HALX5YR1', NULL, NULL);
INSERT INTO device_relationship VALUES ('Q42RKGQ6-R69X3L24-PL4CEHUP', '4OOKBH83-BHYTR4CX-Y5CWIZFU', NULL, '2014-01-16 14:44:40', 'BUFXDN30-YLTMME29-HALX5YR1', NULL, NULL);
INSERT INTO device_relationship VALUES ('WUM830JO-HNBX9PWG-4GQHBQUI', 'G422PTFQ-HY1319TM-27AIRJCB', NULL, '2014-01-16 14:46:22', 'BUFXDN30-YLTMME29-HALX5YR1', NULL, NULL);


--
-- Data for Name: device_session; Type: TABLE DATA; Schema: public; Owner: shiwei
--



--
-- Data for Name: device_value; Type: TABLE DATA; Schema: public; Owner: shiwei
--

INSERT INTO device_value VALUES ('YQTL2XQG-BGBG4UNU-A2CC5JH6', NULL, '1', NULL, NULL, NULL, NULL, '2013-12-23 15:06:43', NULL, '9BWQDRJN-971LW52Y-QPUJRJ5P', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('A22EW6DD-5LFS0ZWZ-ZBZR1AFJ', NULL, '1', NULL, NULL, NULL, NULL, '2013-12-23 15:44:10', NULL, 'FF1234', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('BM0KOQ7E-DBPQAYA0-XN4085X3', NULL, '1', NULL, NULL, NULL, NULL, '2013-12-24 01:57:34', NULL, '2KROTT2J-NUWZW3C4-CH1REK15', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('AN5FMMDU-O297588K-819IOST6', NULL, '1', NULL, NULL, NULL, NULL, '2013-12-23 15:44:18', NULL, '6RZARBQZ-3ZQE3DQX-9LYDJ823', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('B6RRCJ5A-KA60AUY3-E9297XMR', NULL, '1', NULL, NULL, NULL, NULL, '2013-12-30 01:40:37', NULL, 'LKAYSJM2-LKLIC58J-X76UM8HP', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('NCB1X5QE-6592GXJC-7KU5DPWR', NULL, '1', NULL, NULL, NULL, NULL, '2013-12-30 01:42:03', NULL, 'IC41YG7R-3PIAWNTU-UGCDZMR5', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('9TY0GMMK-Z0J6J96X-C9HD6BZN', NULL, '1', NULL, NULL, NULL, NULL, '2013-12-23 15:44:30', NULL, 'A5KINOS4-IOHH7KRR-KC7RZGUM', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('PCW422XF-WRUPZS83-H0Z36QJW', NULL, '1', NULL, NULL, NULL, NULL, '2013-12-23 15:44:25', NULL, 'FDBXULF7-B1LSR9L1-PCLR3XBB', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('IJTF2F7E-6TOHUB21-L0HUBGQD', NULL, '1', NULL, NULL, NULL, NULL, '2013-12-30 02:55:54', NULL, '3BMSRNAS-7NOSQTX0-64J4WZOD', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('O4ZF88KM-Q110WUTM-YJX3LGTI', NULL, '1', NULL, NULL, NULL, NULL, '2013-12-24 09:52:00', NULL, 'MDZM5UFT-M5YRN0UY-AL0B6OQB', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('F70H276R-9E50BOTQ-XCQ598UR', NULL, '1', NULL, NULL, NULL, NULL, '2014-01-02 02:57:25', NULL, '9B3CTRYF-6W8EJIZU-NYMUP252', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('JY4B6SZY-05OC7U74-IB0B6A1J', NULL, '1', NULL, NULL, NULL, NULL, '2014-01-02 03:03:41', NULL, 'YND262IM-RG7WXMEG-DZJECAMB', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('WG779LJ2-GI8AHR27-RG7OB7D3', NULL, '1', NULL, NULL, NULL, NULL, '2014-01-02 03:01:29', NULL, '577HSAAD-02Y2O4WW-BKDPXZ2U', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('3ZTQXQGX-RJYSQM7D-GOJ40YSY', NULL, '1', NULL, NULL, NULL, NULL, '2014-01-08 10:23:06', NULL, 'O2RJ95PR-SH0DE9GD-O7F7PJRT', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('15GYU6A8-XPP6AYKQ-KK7EWUF4', NULL, '1', NULL, NULL, NULL, NULL, '2014-01-08 10:23:18', NULL, 'IQFPZHHE-KXKGG8IT-64NYTUUT', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('W8FQ3FU1-QJKXUSEC-4XOTJ4AA', NULL, '1', NULL, NULL, NULL, NULL, '2014-01-08 10:23:32', NULL, 'Z578OEQB-QRZN9HR9-S8GKH9WL', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('QDLFBRAP-HYGAYAL8-WLO53964', NULL, '1', NULL, NULL, NULL, NULL, '2014-01-16 14:44:40', NULL, '4OOKBH83-BHYTR4CX-Y5CWIZFU', NULL, NULL, NULL);
INSERT INTO device_value VALUES ('XNH3PEPH-U3GKKLPY-L9XP4W2F', NULL, '1', NULL, NULL, NULL, NULL, '2014-01-16 14:46:22', NULL, 'G422PTFQ-HY1319TM-27AIRJCB', NULL, NULL, NULL);


--
-- Data for Name: email; Type: TABLE DATA; Schema: public; Owner: shiwei
--

INSERT INTO email VALUES ('OMGLO2Y2-AE4E1GB2-1DE2UXNS', 'shiweifong@gmail.com', '2013-10-27 06:10:51', NULL, 'BUFXDN30-YLTMME29-HALX5YR1');
INSERT INTO email VALUES ('KG599G2C-8ALL03ZY-IEUN8DJM', 'shiwei@lifeopp.com', '2013-10-27 06:15:30', NULL, 'S230GYZJ-4LMP84BD-R5QW8P42');
INSERT INTO email VALUES ('C79XW1L4-CS6M7N7C-F7EKIGZ6', 'eamon@eyeorcas.com', '2013-11-18 13:30:49', NULL, 'LIUHCGEE-QBC376YD-QMXMSRFO');
INSERT INTO email VALUES ('HHXMHFHJ-R4Q70U5O-GKOKTJSY', 'shiyuan@eyeorcas.com', '2013-11-19 07:49:51', NULL, 'S4M1BTXL-9QLSE54R-XYF3JF2T');
INSERT INTO email VALUES ('T72SA0MB-5UM1DDT9-GNFUCA46', 'xmm@gmail.com', '2013-12-28 05:45:03', NULL, 'ANT3NHSR-5CE2OSCB-QYWDAEPL');
INSERT INTO email VALUES ('B2MW70K7-F3GW56BJ-3KJAH55O', 'yewesther66@gmail.com', '2014-01-18 08:25:15', NULL, 'S93RJ2K9-QEO3N7GS-0QAJZY7U');


--
-- Data for Name: enterprise; Type: TABLE DATA; Schema: public; Owner: shiwei
--



--
-- Data for Name: entity; Type: TABLE DATA; Schema: public; Owner: shiwei
--

INSERT INTO entity VALUES ('BUFXDN30-YLTMME29-HALX5YR1', 'Shi Wei', 'Fong', 'Shi Wei Fong', 'Shi Wei Fong', 'V', true, '1', '2013-10-27 06:10:51', '2013-10-27 06:10:51', 'AON2RRUL-P5KEPL7X-TAK4NZ1G', 'OMGLO2Y2-AE4E1GB2-1DE2UXNS', NULL);
INSERT INTO entity VALUES ('S230GYZJ-4LMP84BD-R5QW8P42', 'Eamon', 'Fong', 'Eamon Fong', 'Eamon Fong', 'V', true, '1', '2013-10-27 06:15:30', '2013-10-27 06:15:30', 'L5A539ZI-A3NZMQJC-4TC06EAR', 'KG599G2C-8ALL03ZY-IEUN8DJM', NULL);
INSERT INTO entity VALUES ('LIUHCGEE-QBC376YD-QMXMSRFO', 'Eamon', 'Fong', 'Eamon Fong', 'Eamon Fong', 'V', true, '1', '2013-11-18 13:30:49', '2013-11-18 13:30:49', 'WS6YR8SY-YI16WQ2F-KIN3HW10', 'C79XW1L4-CS6M7N7C-F7EKIGZ6', NULL);
INSERT INTO entity VALUES ('S4M1BTXL-9QLSE54R-XYF3JF2T', 'Fong', 'Shi Yuan', 'Fong Shi Yuan', 'Fong Shi Yuan', 'V', true, '1', '2013-11-19 07:49:51', '2013-11-19 07:49:51', 'YADEU5AY-DM93A3RY-QCQ2IQPK', 'HHXMHFHJ-R4Q70U5O-GKOKTJSY', NULL);
INSERT INTO entity VALUES ('ANT3NHSR-5CE2OSCB-QYWDAEPL', 'Xiao Mei', 'Peng', 'Xiao Mei Peng', 'Xiao Mei Peng', 'V', true, '1', '2013-12-28 05:45:03', '2013-12-28 05:45:03', 'OF8MUPGU-TXI4IO3R-F3GOJPA6', 'T72SA0MB-5UM1DDT9-GNFUCA46', NULL);
INSERT INTO entity VALUES ('S93RJ2K9-QEO3N7GS-0QAJZY7U', 'Bee Hua', 'Yes', 'Bee Hua Yes', 'Bee Hua Yes', 'V', true, '1', '2014-01-18 08:25:15', '2014-01-18 08:25:15', 'AMP8QLLA-TMULTIEQ-FLPUTQSH', 'B2MW70K7-F3GW56BJ-3KJAH55O', NULL);


--
-- Data for Name: log; Type: TABLE DATA; Schema: public; Owner: shiwei
--

INSERT INTO log VALUES ('X3D24RFX-R3WKF3UY-M4ZWEJET', 'test syslog', 'Connection', 'Correct syslog', NULL, 'V', '2014-01-13 11:16:00', 'BUFXDN30-YLTMME29-HALX5YR1', 'Z578OEQB-QRZN9HR9-S8GKH9WL');
INSERT INTO log VALUES ('8WLDKBC8-5G00Z5NG-Z9Q42CSF', 'test syslog', 'Connection', 'Correct syslog', NULL, 'V', '2014-01-13 11:16:00', 'BUFXDN30-YLTMME29-HALX5YR1', 'Z578OEQB-QRZN9HR9-S8GKH9WL');
INSERT INTO log VALUES ('6I2AR6UP-S6S48W24-2STQO7YD', 'test syslog', 'Connection', 'Correct syslog', NULL, 'V', '2014-01-13 11:16:00', 'BUFXDN30-YLTMME29-HALX5YR1', 'Z578OEQB-QRZN9HR9-S8GKH9WL');
INSERT INTO log VALUES ('4G4FIRM8-KFMG7BXQ-UOXLCGMU', 'Correct syslog', 'Connection', 'test type', NULL, 'V', '2014-01-14 02:32:16', 'BUFXDN30-YLTMME29-HALX5YR1', 'Z578OEQB-QRZN9HR9-S8GKH9WL');
INSERT INTO log VALUES ('JZ8FRG6M-N0RWI5US-A8Z89MOU', 'Correct syslog', 'Connection', 'test type', NULL, 'V', '2014-01-14 02:32:16', 'BUFXDN30-YLTMME29-HALX5YR1', 'Z578OEQB-QRZN9HR9-S8GKH9WL');
INSERT INTO log VALUES ('1C64IJPS-8NZQUU48-LLUUHFDI', 'Correct syslog', 'Connection', 'test type', NULL, 'V', '2014-01-14 02:32:16', 'BUFXDN30-YLTMME29-HALX5YR1', 'Z578OEQB-QRZN9HR9-S8GKH9WL');
INSERT INTO log VALUES ('D3HCFXY7-ZT184GQ3-TGJF2DDD', 'Correct syslog', 'Connection', 'test type', NULL, 'V', '2014-01-14 02:32:16', 'BUFXDN30-YLTMME29-HALX5YR1', 'Z578OEQB-QRZN9HR9-S8GKH9WL');
INSERT INTO log VALUES ('1234', 'testing message', 'Connection', NULL, NULL, 'V', '2014-01-13 11:16:00', 'BUFXDN30-YLTMME29-HALX5YR1', 'Z578OEQB-QRZN9HR9-S8GKH9WL');
INSERT INTO log VALUES ('321', 'second msg', 'Conn', NULL, '', 'V', '2014-01-11 11:16:00', 'BUFXDN30-YLTMME29-HALX5YR1', 'Z578OEQB-QRZN9HR9-S8GKH9WL');


--
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: shiwei
--

INSERT INTO media VALUES ('KXG4MUSS-N6MIMGPJ-0T8QPUYH', 'White girls in the club', NULL, 'White-girls-in-the-club-be-like.mp4', 'http://vine-videos.com/wp-content/uploads/2013/08/White-girls-in-the-club-be-like.mp4', 'V', '2013-12-23 15:04:43', '2KROTT2J-NUWZW3C4-CH1REK15', 'This is a test vine video', 'mp4', 'http://vine-videos.com/wp-content/uploads/2013/12/Best-Vines-Shootout-Goal1_thumb2.jpg', NULL, NULL, NULL, NULL, NULL);
INSERT INTO media VALUES ('8Z5SXLOX-HT6PY6CJ-QSE9UA25', 'Open fresh pack of 5 Gum', NULL, 'When-you-open-a-fresh-pack-of-5-Gum.mp4', 'http://vine-videos.com/wp-content/uploads/2013/08/When-you-open-a-fresh-pack-of-5-Gum.mp4', 'V', '2013-12-23 15:04:43', '2KROTT2J-NUWZW3C4-CH1REK15', 'This is a test vine video', 'mp4', 'http://vine-videos.com/wp-content/uploads/2013/12/Best-Vines-Shootout-Goal1_thumb2.jpg', NULL, NULL, NULL, NULL, NULL);
INSERT INTO media VALUES ('RQNMKDOB-OTD7K9U6-77WI2RN3', 'Motivation', NULL, 'Motivation.mp4', 'http://vine-videos.com/wp-content/uploads/2013/08/Motivation.mp4', 'V', '2013-12-23 15:04:43', '2KROTT2J-NUWZW3C4-CH1REK15', 'This is a test vine video', 'mp4', 'http://vine-videos.com/wp-content/uploads/2013/12/Best-Vines-Shootout-Goal1_thumb2.jpg', NULL, NULL, NULL, NULL, NULL);
INSERT INTO media VALUES ('6CKD4LQK-60HU3UAC-312MWTAS', 'London clock late', NULL, 'Dear-London-your-clock-was-running-a-little-late.mp4', 'http://vine-videos.com/wp-content/uploads/2013/07/Dear-London-your-clock-was-running-a-little-late.mp4', 'V', '2013-12-23 15:04:43', '2KROTT2J-NUWZW3C4-CH1REK15', 'This is a test vine video', 'mp4', 'http://vine-videos.com/wp-content/uploads/2013/12/Best-Vines-Shootout-Goal1_thumb2.jpg', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: shiwei
--



--
-- Data for Name: module; Type: TABLE DATA; Schema: public; Owner: shiwei
--



--
-- Data for Name: module_registration; Type: TABLE DATA; Schema: public; Owner: shiwei
--



--
-- Data for Name: phone; Type: TABLE DATA; Schema: public; Owner: shiwei
--

INSERT INTO phone VALUES ('1DUAJ36T-IZU2NED0-67OBSOA3', '+6597318822', 'sg', '65', '2013-12-19 10:17:20', NULL, NULL, 'FF1234', '97318822');
INSERT INTO phone VALUES ('WAJHWL0A-Y3AAZOZ8-8W6AMMH8', '+6596820058', 'sg', '65', '2013-12-19 11:26:33', NULL, NULL, 'FF1234', '96820058');
INSERT INTO phone VALUES ('QP5WQNPS-0CZG94EX-OSYS2R27', '+24417682347612', 'ao', '244', '2013-12-19 11:39:42', NULL, NULL, 'FF1234', '17682347612');
INSERT INTO phone VALUES ('KUQOYEGD-D96TLQD6-UPZ0TJHE', '+65892734234', 'sg', '65', '2013-12-19 14:15:43', NULL, NULL, 'FF1234', '892734234');
INSERT INTO phone VALUES ('3XBP2THW-LE0PKLE0-CWTXO8T6', '+6596820058', 'sg', '65', '2013-12-21 11:46:27', NULL, NULL, '3BMSRNAS-7NOSQTX0-64J4WZOD', '96820058');
INSERT INTO phone VALUES ('CS78IWP1-C5QOXS65-UJAU9MYU', '+6597318822', 'sg', '65', '2013-12-21 23:51:15', NULL, NULL, '3BMSRNAS-7NOSQTX0-64J4WZOD', '97318822');
INSERT INTO phone VALUES ('5S475YWL-3F600XOP-AGMLZOR1', '+651234588', 'sg', '65', '2013-12-30 02:47:03', NULL, NULL, 'A5KINOS4-IOHH7KRR-KC7RZGUM', '1234588');
INSERT INTO phone VALUES ('GQ940MM3-4056SHHP-I6YK8M62', '+6596820058', 'sg', '65', '2013-12-30 02:44:38', NULL, NULL, 'A5KINOS4-IOHH7KRR-KC7RZGUM', '96820058');
INSERT INTO phone VALUES ('KSXXFLEX-KDOPDLUI-OAH2SWOJ', '+6512345678', 'sg', '65', '2013-12-30 02:47:28', NULL, NULL, 'A5KINOS4-IOHH7KRR-KC7RZGUM', '12345678');
INSERT INTO phone VALUES ('HMASTYXB-FPWCAIUA-UF5Z43DQ', '+6596820058', 'sg', '65', '2013-12-30 02:48:16', NULL, NULL, 'A5KINOS4-IOHH7KRR-KC7RZGUM', '96820058');
INSERT INTO phone VALUES ('KTFG5ZXH-XQ5RXQUM-J19XS93Z', '+6597318822', 'sg', '65', '2013-12-30 02:50:21', NULL, NULL, 'FDBXULF7-B1LSR9L1-PCLR3XBB', '97318822');
INSERT INTO phone VALUES ('S7NWE6TA-R3SQXJCL-AMMOSYED', '+6512345678', 'sg', '65', '2013-12-30 02:56:37', NULL, NULL, '3BMSRNAS-7NOSQTX0-64J4WZOD', '12345678');
INSERT INTO phone VALUES ('OJ08FNQM-IBP2MWFL-17SWELCZ', '+6596820058', 'sg', '65', '2014-01-08 10:20:36', NULL, NULL, '577HSAAD-02Y2O4WW-BKDPXZ2U', '96820058');


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: shiwei
--

INSERT INTO product VALUES ('NW41GL7D-2ZQLOTQB-1INKCWE0', 'Alpha Starter', 'Alpha starter account.', 'A', 'V', NULL, NULL, 'EYEORCAS-STARTER');


--
-- Data for Name: product_registration; Type: TABLE DATA; Schema: public; Owner: shiwei
--

INSERT INTO product_registration VALUES ('CC5JH6K9-N2WPY7YU-ZB35TM5J', 'V', NULL, 'NW41GL7D-2ZQLOTQB-1INKCWE0', 'BUFXDN30-YLTMME29-HALX5YR1', '2013-12-09 14:03:07', NULL);
INSERT INTO product_registration VALUES ('3UHJU9Y4-PHUPRS3A-LXYCB1BT', 'V', NULL, 'NW41GL7D-2ZQLOTQB-1INKCWE0', 'S230GYZJ-4LMP84BD-R5QW8P42', '2013-12-09 16:10:36', NULL);
INSERT INTO product_registration VALUES ('Z1JG2BM0-D3B70KE0-JHAX30RW', 'V', NULL, 'NW41GL7D-2ZQLOTQB-1INKCWE0', 'LIUHCGEE-QBC376YD-QMXMSRFO', '2013-12-09 16:13:03', NULL);
INSERT INTO product_registration VALUES ('8X7D2DGD-65UCOF88-6XZJPWU8', 'V', NULL, 'NW41GL7D-2ZQLOTQB-1INKCWE0', 'S4M1BTXL-9QLSE54R-XYF3JF2T', '2013-12-09 16:13:26', NULL);
INSERT INTO product_registration VALUES ('996BNB77-Z9KXWEPK-LLLRW7OL', 'V', NULL, 'NW41GL7D-2ZQLOTQB-1INKCWE0', 'S93RJ2K9-QEO3N7GS-0QAJZY7U', '2014-01-18 08:46:14', NULL);


--
-- Data for Name: product_value; Type: TABLE DATA; Schema: public; Owner: shiwei
--

INSERT INTO product_value VALUES ('7X48UGQR-G4J4AOGU-1IY4XH1H', 'Storage', 500, NULL, NULL, 'GB', 'V', 'S', NULL, NULL, 'NW41GL7D-2ZQLOTQB-1INKCWE0');
INSERT INTO product_value VALUES ('AC669JLF-1T0CD61M-P1QGTEQL', 'Push Notification', 5000, NULL, NULL, NULL, 'V', 'P', NULL, NULL, 'NW41GL7D-2ZQLOTQB-1INKCWE0');
INSERT INTO product_value VALUES ('IOIOS1R6-DAWZR48J-4SMU00EE', 'SMS', 5000, NULL, NULL, NULL, 'V', 'M', NULL, NULL, 'NW41GL7D-2ZQLOTQB-1INKCWE0');


--
-- Name: address_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (address_id);


--
-- Name: authentication_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY authentication
    ADD CONSTRAINT authentication_pkey PRIMARY KEY (authentication_id);


--
-- Name: configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY configuration
    ADD CONSTRAINT configuration_pkey PRIMARY KEY (configuration_id);


--
-- Name: device_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY device
    ADD CONSTRAINT device_pkey PRIMARY KEY (device_id);


--
-- Name: device_relationship_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY device_relationship
    ADD CONSTRAINT device_relationship_pkey PRIMARY KEY (device_relationship_id);


--
-- Name: device_value_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY device_value
    ADD CONSTRAINT device_value_pkey PRIMARY KEY (device_value_id);


--
-- Name: email_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY email
    ADD CONSTRAINT email_pkey PRIMARY KEY (email_id);


--
-- Name: enterprise_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY enterprise
    ADD CONSTRAINT enterprise_pkey PRIMARY KEY (enterprise_id);


--
-- Name: entity_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY entity
    ADD CONSTRAINT entity_pkey PRIMARY KEY (entity_id);


--
-- Name: log_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY log
    ADD CONSTRAINT log_pkey PRIMARY KEY (log_id);


--
-- Name: media_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_pkey PRIMARY KEY (media_id);


--
-- Name: message_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY message
    ADD CONSTRAINT message_pkey PRIMARY KEY (message_id);


--
-- Name: module_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY module
    ADD CONSTRAINT module_pkey PRIMARY KEY (module_id);


--
-- Name: module_registration_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY module_registration
    ADD CONSTRAINT module_registration_pkey PRIMARY KEY (module_registration_id);


--
-- Name: phone_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY phone
    ADD CONSTRAINT phone_pkey PRIMARY KEY (phone_id);


--
-- Name: product_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- Name: product_registration_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY product_registration
    ADD CONSTRAINT product_registration_pkey PRIMARY KEY (product_registration_id);


--
-- Name: product_value_pkey; Type: CONSTRAINT; Schema: public; Owner: shiwei; Tablespace: 
--

ALTER TABLE ONLY product_value
    ADD CONSTRAINT product_value_pkey PRIMARY KEY (product_value_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: shiwei
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM shiwei;
GRANT ALL ON SCHEMA public TO shiwei;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- shiweiQL database dump complete
--

