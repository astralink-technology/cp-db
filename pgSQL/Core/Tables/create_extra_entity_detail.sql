CREATE TABLE extra_entity_detail (
  extra_entity_detail_id varchar(32) primary key,
  related_detail_id varchar(32),
  related_detail_id2 varchar(32),
  related_detail_id3 varchar(32),
  related_detail_id4 varchar(32),
  date_time_detail timestamp without time zone,
  date_time_detail2 timestamp without time zone,
  date_time_detail3 timestamp without time zone,
  date_time_detail4 timestamp without time zone,
  int_detail integer,
  int_detail2 integer,
  int_detail3 integer,
  int_detail4 integer,
  detail varchar(128),
  detail2 varchar(128),
  detail3 varchar(128),
  detail4 varchar(128),
  create_date timestamp without time zone,
  last_update timestamp without time zone,
  owner_id varchar(32)
);