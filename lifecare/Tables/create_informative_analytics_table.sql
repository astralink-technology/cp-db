create table informative_analytics (
	informative_analytics_id varchar(32) primary key,
  name varchar(32),
  date_value timestamp without time zone,
  date_value2 timestamp without time zone,
  date_value3 timestamp without time zone,
  date_value4 timestamp without time zone,
  value varchar(32),
  value2 varchar(32),
  value3 varchar(32),
  value4 varchar(32),
  int_value integer,
  int_value2 integer,
  int_value3 integer,
  int_value4 integer,
  type varchar(8),
	create_date timestamp without time zone,
	owner_id varchar(32)
);