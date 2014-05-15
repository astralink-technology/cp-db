create table module_registration (
	module_registration_id varchar(32) primary key,
	module_id varchar(32),
	enterprise_id varchar(32),
	status char(1),
	create_date timestamp without time zone
);