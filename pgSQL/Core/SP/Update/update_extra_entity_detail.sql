-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'update_extra_entity_detail' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION update_extra_entity_detail(
    pExtraEntityDetailId varchar(32)
    , pRelatedDetailId varchar(32)
    , pRelatedDetailId2 varchar(32)
    , pRelatedDetailId3 varchar(32)
    , pRelatedDetailId4 varchar(32)
    , pDateTimeDetail timestamp without time zone
    , pDateTimeDetail2 timestamp without time zone
    , pDateTimeDetail3 timestamp without time zone
    , pDateTimeDetail4 timestamp without time zone
    , pIntDetail integer
    , pIntDetail2 integer
    , pIntDetail3 integer
    , pIntDetail4 integer
    , pDetail varchar(128)
    , pDetail2 varchar(128)
    , pDetail3 varchar(128)
    , pDetail4 varchar(128)
    , pLastUpdate timestamp without time zone
)
RETURNS BOOL AS 
$BODY$
DECLARE
    nRelatedDetailId varchar(32);
    nRelatedDetailId2 varchar(32);
    nRelatedDetailId3 varchar(32);
    nRelatedDetailId4 varchar(32);
    nDateTimeDetail timestamp without time zone;
    nDateTimeDetail2 timestamp without time zone;
    nDateTimeDetail3 timestamp without time zone;
    nDateTimeDetail4 timestamp without time zone;
    nIntDetail integer;
    nIntDetail2 integer;
    nIntDetail3 integer;
    nIntDetail4 integer;
    nDetail varchar(128);
    nDetail2 varchar(128);
    nDetail3 varchar(128);
    nDetail4 varchar(128);
    nLastUpdate timestamp without time zone;

    oRelatedDetailId varchar(32);
    oRelatedDetailId2 varchar(32);
    oRelatedDetailId3 varchar(32);
    oRelatedDetailId4 varchar(32);
    oDateTimeDetail timestamp without time zone;
    oDateTimeDetail2 timestamp without time zone;
    oDateTimeDetail3 timestamp without time zone;
    oDateTimeDetail4 timestamp without time zone;
    oIntDetail integer;
    oIntDetail2 integer;
    oIntDetail3 integer;
    oIntDetail4 integer;
    oDetail varchar(128);
    oDetail2 varchar(128);
    oDetail3 varchar(128);
    oDetail4 varchar(128);
    oLastUpdate timestamp without time zone;
BEGIN
    -- ID is needed if not return
    IF oExtraEntityDetailId IS NULL THEN
        RETURN FALSE;
    ELSE
        -- select the variables into the old variables
        SELECT
          ee.related_detail_id
          , ee.related_detail_id2
          , ee.related_detail_id3
          , ee.related_detail_id4
          , ee.date_time_detail
          , ee.date_time_detail2
          , ee.date_time_detail3
          , ee.date_time_detail4
          , ee.int_detail
          , ee.int_detail2
          , ee.int_detail3
          , ee.int_detail4
          , ee.detail
          , ee.detail2
          , ee.detail3
          , ee.detail4
          , ee.last_update
        INTO STRICT
          oRelatedDetailId
          , oRelatedDetailId2
          , oRelatedDetailId3
          , oRelatedDetailId4
          , oDateTimeDetail
          , oDateTimeDetail2
          , oDateTimeDetail3
          , oDateTimeDetail4
          , oIntDetail
          , oIntDetail2
          , oIntDetail3
          , oIntDetail4
          , oDetail
          , oDetail2
          , oDetail3
          , oDetail4
          , oLastUpdate
        FROM extra_entity_detail ee WHERE
          ee.extra_entity_detail_id = pExtraEntityDetailId;

        -- Start the updating process
        IF pRelatedDetailId IS NULL THEN 
            nRelatedDetailId := oRelatedDetailId;
        ELSEIF pRelatedDetailId = '' THEN
            nRelatedDetailId := NULL;
        ELSE
            nRelatedDetailId := pRelatedDetailId;
        END IF;
      
        IF pRelatedDetailId2 IS NULL THEN
            nRelatedDetailId2 := oRelatedDetailId2;
        ELSEIF pRelatedDetailId2 = '' THEN
            nRelatedDetailId2 := NULL;
        ELSE
            nRelatedDetailId2 := pRelatedDetailId2;
        END IF;
      
        IF pRelatedDetailId3 IS NULL THEN
            nRelatedDetailId3 := oRelatedDetailId3;
        ELSEIF pRelatedDetailId3 = '' THEN
            nRelatedDetailId3 := NULL;
        ELSE
            nRelatedDetailId3 := pRelatedDetailId3;
        END IF;
      
        IF pRelatedDetailId4 IS NULL THEN
            nRelatedDetailId4 := oRelatedDetailId4;
        ELSEIF pRelatedDetailId4 = '' THEN
            nRelatedDetailId4 := NULL;
        ELSE
            nRelatedDetailId4 := pRelatedDetailId4;
        END IF;

        IF pDateTimeDetail IS NULL THEN
            nDateTimeDetail := oDateTimeDetail;
        ELSE
            nDateTimeDetail := pDateTimeDetail;
        END IF;

        IF pDateTimeDetail2 IS NULL THEN
            nDateTimeDetail2 := oDateTimeDetail2;
        ELSE
            nDateTimeDetail2 := pDateTimeDetail2;
        END IF;
      
        IF pDateTimeDetail3 IS NULL THEN
            nDateTimeDetail3 := oDateTimeDetail3;
        ELSE
            nDateTimeDetail3 := pDateTimeDetail3;
        END IF;

        IF pDateTimeDetail4 IS NULL THEN
          nDateTimeDetail4 := oDateTimeDetail4;
        ELSE
          nDateTimeDetail4 := pDateTimeDetail4;
        END IF;
  
        IF pIntDetail IS NULL THEN
          nIntDetail := oIntDetail;
        ELSEIF pIntDetail = '' THEN
          nIntDetail := NULL;
        ELSE
          nIntDetail := pIntDetail;
        END IF;
  
        IF pIntDetail2 IS NULL THEN
          nIntDetail2 := oIntDetail2;
        ELSEIF pIntDetail2 = '' THEN
          nIntDetail2 := NULL;
        ELSE
          nIntDetail2 := pIntDetail2;
        END IF;
  
        IF pIntDetail3 IS NULL THEN
          nIntDetail3 := oIntDetail3;
        ELSEIF pIntDetail3 = '' THEN
          nIntDetail3 := NULL;
        ELSE
          nIntDetail3 := pIntDetail3;
        END IF;
  
        IF pIntDetail4 IS NULL THEN
          nIntDetail4 := oIntDetail4;
        ELSEIF pIntDetail4 = '' THEN
          nIntDetail4 := NULL;
        ELSE
          nIntDetail4 := pIntDetail4;
        END IF;
      
        IF pDetail IS NULL THEN
          nDetail := oDetail;
        ELSEIF pDetail = '' THEN
          nDetail := NULL;
        ELSE
          nDetail := pDetail;
        END IF;
  
        IF pDetail2 IS NULL THEN
          nDetail2 := oDetail2;
        ELSEIF pDetail2 = '' THEN
          nDetail2 := NULL;
        ELSE
          nDetail2 := pDetail2;
        END IF;
  
        IF pDetail3 IS NULL THEN
          nDetail3 := oDetail3;
        ELSEIF pDetail3 = '' THEN
          nDetail3 := NULL;
        ELSE
          nDetail3 := pDetail3;
        END IF;
  
        IF pDetail4 IS NULL THEN
          nDetail4 := oDetail4;
        ELSEIF pDetail4 = '' THEN
          nDetail4 := NULL;
        ELSE
          nDetail4 := pDetail4;
        END IF;
        
        IF pLastUpdate IS NULL THEN
            nLastUpdate := oLastUpdate;
        ELSE
            nLastUpdate := pLastUpdate;
        END IF;


        -- start the update
        UPDATE 
            extra_entity_detail
        SET
            related_detail_id = nRelatedDetailId
            , related_detail_id2 = nRelatedDetailId2
            , related_detail_id3 = nRelatedDetailId3
            , related_detail_id4 = nRelatedDetailId4
            , date_time_detail = nDateTimeDetail
            , date_time_detail2 = nDateTimeDetail2
            , date_time_detail3 = nDateTimeDetail3
            , date_time_detail4 = nDateTimeDetail4
            , int_detail = nIntDetail
            , int_detail2 = nIntDetail2
            , int_detail3 = nIntDetail3
            , int_detail4 = nIntDetail4
            , detail = nDetail
            , detail2 = nDetail2
            , detail3 = nDetail3
            , detail4 = nDetail4
            , last_update = nLastUpdate
        WHERE 
            extra_entity_detail_id = pExtraEntityDetailId;
        RETURN TRUE;

    END IF;
END;
$BODY$
LANGUAGE plpgsql;

