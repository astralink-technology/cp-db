-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_extra_entity_detail' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_extra_entity_detail(
          pExtraEntityDetailId varchar(32)
          , pRelatedDetailId varchar(32)
          , pRelatedDetailId2 varchar(32)
          , pRelatedDetailId3 varchar(32)
          , pRelatedDetailId4 varchar(32)
          , pDateTimeDetail timestamp without time zone
          , pDateTimeDetailTimeStart timestamp without time zone
          , pDateTimeDetailTimeEnd timestamp without time zone
          , pDateTimeDetail2 timestamp without time zone
          , pDateTimeDetail2TimeStart timestamp without time zone
          , pDateTimeDetail2TimeEnd timestamp without time zone
          , pDateTimeDetail3 timestamp without time zone
          , pDateTimeDetail3TimeStart timestamp without time zone
          , pDateTimeDetail3TimeEnd timestamp without time zone
          , pDateTimeDetail4 timestamp without time zone
          , pDateTimeDetail4TimeStart timestamp without time zone
          , pDateTimeDetail4TimeEnd timestamp without time zone
          , pIntDetail integer
          , pIntDetail2 integer
          , pIntDetail3 integer
          , pIntDetail4 integer
          , pDetail varchar(128)
          , pDetail2 varchar(128)
          , pDetail3 varchar(128)
          , pDetail4 varchar(128)
          , pOwnerId varchar(32)
          , pPageSize integer
          , pSkipSize integer
    )
RETURNS TABLE(
    extra_entity_detail_id varchar(32)
    , related_detail_id varchar(32)
    , related_detail_id2 varchar(32)
    , related_detail_id3 varchar(32)
    , related_detail_id4 varchar(32)
    , date_time_detail timestamp without time zone
    , date_time_detail2 timestamp without time zone
    , date_time_detail3 timestamp without time zone
    , date_time_detail4 timestamp without time zone
    , int_detail integer
    , int_detail2 integer
    , int_detail3 integer
    , int_detail4 integer
    , detail varchar(128)
    , detail2 varchar(128)
    , detail3 varchar(128)
    , detail4 varchar(128)
    , create_date timestamp without time zone
    , last_update timestamp without time zone
    , owner_id varchar(32)
    , totalRows integer
) AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM extra_entity_detail e WHERE (
      ((pExtraEntityDetailId IS NULL) OR (e.extra_entity_detail_id = pExtraEntityDetailId )) AND
      ((pRelatedDetailId IS NULL) OR (e.related_detail_id = pRelatedDetailId)) AND
      ((pRelatedDetailId2 IS NULL) OR (e.related_detail_id2 = pRelatedDetailId2)) AND
      ((pRelatedDetailId3 IS NULL) OR (e.related_detail_id3 = pRelatedDetailId3)) AND
      ((pRelatedDetailId4 IS NULL) OR (e.related_detail_id4 = pRelatedDetailId4)) AND
      ((pDateTimeDetail IS NULL) OR (e.date_time_detail = pDateTimeDetail)) AND
      ((pDateTimeDetail2 IS NULL) OR (e.date_time_detail2 = pDateTimeDetail2)) AND
      ((pDateTimeDetail3 IS NULL) OR (e.date_time_detail3 = pDateTimeDetail3)) AND
      ((pDateTimeDetail4 IS NULL) OR (e.date_time_detail4 = pDateTimeDetail4)) AND
      ((pDateTimeDetailTimeStart IS NULL OR pDateTimeDetailTimeEnd IS NULL) OR (e.date_time_detail BETWEEN pDateTimeDetailTimeStart AND pDateTimeDetailTimeEnd)) AND
      ((pDateTimeDetail2TimeStart IS NULL OR pDateTimeDetail2TimeEnd IS NULL) OR (e.date_time_detail2 BETWEEN pDateTimeDetail2TimeStart AND pDateTimeDetail2TimeEnd)) AND
      ((pDateTimeDetail3TimeStart IS NULL OR pDateTimeDetail3TimeEnd IS NULL) OR (e.date_time_detail3 BETWEEN pDateTimeDetail3TimeStart AND pDateTimeDetail3TimeEnd)) AND
      ((pDateTimeDetail4TimeStart IS NULL OR pDateTimeDetail4TimeEnd IS NULL) OR (e.date_time_detail4 BETWEEN pDateTimeDetail4TimeStart AND pDateTimeDetail4TimeEnd)) AND
      ((pIntDetail IS NULL) OR (e.int_detail = pIntDetail)) AND
      ((pIntDetail2 IS NULL) OR (e.int_detail2 = pIntDetail2)) AND
      ((pIntDetail3 IS NULL) OR (e.int_detail3 = pIntDetail3)) AND
      ((pIntDetail4 IS NULL) OR (e.int_detail4 = pIntDetail4)) AND
      ((pDetail IS NULL) OR (e.detail = pDetail)) AND
      ((pDetail2 IS NULL) OR (e.detail2 = pDetail2)) AND
      ((pDetail3 IS NULL) OR (e.detail3 = pDetail3)) AND
      ((pDetail4 IS NULL) OR (e.detail4 = pDetail4)) AND
      ((pOwnerId IS NULL) OR (e.owner_id = pOwnerId))
	  );

    -- create a temp table to get the data
    CREATE TEMP TABLE extra_entity_detail_init AS
      SELECT
        ee.extra_entity_detail_id
        , ee.related_detail_id
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
        , ee.create_date
        , ee.last_update
        , ee.owner_id
      FROM extra_entity_detail ee  WHERE (
        ((pExtraEntityDetailId IS NULL) OR (ee.extra_entity_detail_id = pExtraEntityDetailId )) AND
        ((pRelatedDetailId IS NULL) OR (ee.related_detail_id = pRelatedDetailId)) AND
        ((pRelatedDetailId2 IS NULL) OR (ee.related_detail_id2 = pRelatedDetailId2)) AND
        ((pRelatedDetailId3 IS NULL) OR (ee.related_detail_id3 = pRelatedDetailId3)) AND
        ((pRelatedDetailId4 IS NULL) OR (ee.related_detail_id4 = pRelatedDetailId4)) AND
        ((pDateTimeDetail IS NULL) OR (ee.date_time_detail = pDateTimeDetail)) AND
        ((pDateTimeDetail2 IS NULL) OR (ee.date_time_detail2 = pDateTimeDetail2)) AND
        ((pDateTimeDetail3 IS NULL) OR (ee.date_time_detail3 = pDateTimeDetail3)) AND
        ((pDateTimeDetail4 IS NULL) OR (ee.date_time_detail4 = pDateTimeDetail4)) AND
        ((pDateTimeDetailTimeStart IS NULL OR pDateTimeDetailTimeEnd IS NULL) OR (ee.date_time_detail BETWEEN pDateTimeDetailTimeStart AND pDateTimeDetailTimeEnd)) AND
        ((pDateTimeDetail2TimeStart IS NULL OR pDateTimeDetail2TimeEnd IS NULL) OR (ee.date_time_detail2 BETWEEN pDateTimeDetail2TimeStart AND pDateTimeDetail2TimeEnd)) AND
        ((pDateTimeDetail3TimeStart IS NULL OR pDateTimeDetail3TimeEnd IS NULL) OR (ee.date_time_detail3 BETWEEN pDateTimeDetail3TimeStart AND pDateTimeDetail3TimeEnd)) AND
        ((pDateTimeDetail4TimeStart IS NULL OR pDateTimeDetail4TimeEnd IS NULL) OR (ee.date_time_detail4 BETWEEN pDateTimeDetail4TimeStart AND pDateTimeDetail4TimeEnd)) AND
        ((pIntDetail IS NULL) OR (ee.int_detail = pIntDetail)) AND
        ((pIntDetail2 IS NULL) OR (ee.int_detail2 = pIntDetail2)) AND
        ((pIntDetail3 IS NULL) OR (ee.int_detail3 = pIntDetail3)) AND
        ((pIntDetail4 IS NULL) OR (ee.int_detail4 = pIntDetail4)) AND
        ((pDetail IS NULL) OR (ee.detail = pDetail)) AND
        ((pDetail2 IS NULL) OR (ee.detail2 = pDetail2)) AND
        ((pDetail3 IS NULL) OR (ee.detail3 = pDetail3)) AND
        ((pDetail4 IS NULL) OR (ee.detail4 = pDetail4)) AND
        ((pOwnerId IS NULL) OR (ee.owner_id = pOwnerId))
      )
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM extra_entity_detail_init;

END;
$BODY$
LANGUAGE plpgsql;