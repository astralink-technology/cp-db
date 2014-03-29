create table device_value (
	device_value_id varchar(32) primary key,
	push char(1),
	sms char(1),
	token varchar(128),
	resolution varchar(16),
	hash varchar(60),
	salt varchar(16),
	description text,
	quality varchar(16),
	type varchar(32),
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	device_id varchar(32)
);