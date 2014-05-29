create table analytics_value (
	analytics_value_id varchar(32) primary key,
  analytics_value_name varchar(32),
  date_value timestamp without time zone,
  date_value2 timestamp without time zone,
  date_value3 timestamp without time zone,
  value varchar(32),
  value2 varchar(32),
  int_value integer,
  int_value2 integer,
  type char(1),
	create_date timestamp without time zone,
	owner_id varchar(32)
);