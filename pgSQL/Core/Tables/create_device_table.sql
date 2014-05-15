create table device (
	device_id varchar(32) primary key,
	name varchar(32),
	code varchar(32),
	status char(1),
	type char(1),
	type2 char(1),
	description text,
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	owner_id varchar(32)
);