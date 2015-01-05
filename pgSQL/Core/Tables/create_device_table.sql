create table device (
	device_id varchar(32) primary key,
	name varchar(32),
	code varchar(32),
	status char(1),
	type varchar(4),
	type2 varchar(4),
	description text,
	deployment_date date,
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	owner_id varchar(32)
);