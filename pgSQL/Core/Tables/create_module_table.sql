create table module (
	module_id varchar(32) primary key,
	name varchar(64),
	slug varchar(32),
	status char(1),
	create_date timestamp without time zone
);