-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'add_extra_entity_detail' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION add_extra_entity_detail(
        pExtraEntityDetailId varchar(32),
        pRelatedDetailId varchar(32),
        pRelatedDetailId2 varchar(32),
        pRelatedDetailId3 varchar(32),
        pRelatedDetailId4 varchar(32),
        pDateTimeDetail timestamp without time zone,
        pDateTimeDetail2 timestamp without time zone,
        pDateTimeDetail3 timestamp without time zone,
        pDateTimeDetail4 timestamp without time zone,
        pIntDetail integer,
        pIntDetail2 integer,
        pIntDetail3 integer,
        pIntDetail4 integer,
        pDetail varchar(128),
        pDetail2 varchar(128),
        pDetail3 varchar(128),
        pDetail4 varchar(128),
        pCreateDate timestamp without time zone,
        pLastUpdate timestamp without time zone,
        pOwnerId varchar(32)
)
RETURNS varchar(32) AS 
$BODY$
BEGIN
    INSERT INTO extra_entity_detail (
      extra_entity_detail_id
      , related_detail_id
      , related_detail_id2
      , related_detail_id3
      , related_detail_id4
      , date_time_detail
      , date_time_detail2
      , date_time_detail3
      , date_time_detail4
      , int_detail
      , int_detail2
      , int_detail3
      , int_detail4
      , detail
      , detail2
      , detail3
      , detail4
      , create_date
      , last_update
      , owner_id
    ) VALUES(
      pExtraEntityDetailId
      , pRelatedDetailId
      , pRelatedDetailId2
      , pRelatedDetailId3
      , pRelatedDetailId4
      , pDateTimeDetail
      , pDateTimeDetail2
      , pDateTimeDetail3
      , pDateTimeDetail4
      , pIntDetail
      , pIntDetail2
      , pIntDetail3
      , pIntDetail4
      , pDetail
      , pDetail2
      , pDetail3
      , pDetail4
      , pCreateDate
      , pLastUpdate
      , pOwnerId
    );
    RETURN pExtraEntityDetailId;
END;
$BODY$
LANGUAGE plpgsql;