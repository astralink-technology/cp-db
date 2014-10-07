CREATE TABLE attendance (
  attendance_id varchar(32) primary key,
  name varchar(64),
  type char(1),
  time_in timestamp without time zone,
  time_out timestamp without time zone,
  create_date timestamp without time zone,
  last_update timestamp without time zone,
  owner_id varchar(32)
);