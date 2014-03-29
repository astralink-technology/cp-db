create table message (
	message_id varchar(32) primary key,
	subject varchar(128),
	message text,
  type char (1),
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	owner_id varchar(32),
	trigger_event char(2)
);
