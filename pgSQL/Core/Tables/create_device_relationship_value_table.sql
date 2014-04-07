create table device_relationship_value (
	device_relationship_value_id varchar(32) primary key,
  name varchar(64),
	push char(1),
	sms char(1),
	token varchar(128),
	resolution varchar(16),
	hash varchar(60),
	salt varchar(16),
	description text,
	quality varchar(16),
	type char(1),
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	device_relationship_id varchar(32),
	app_version varchar(16),
	firmware_version varchar(16)
);
