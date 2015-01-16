create table entity (
	entity_id varchar(32) primary key, 
	first_name varchar(128),
	last_name varchar(128),
	nick_name varchar(256),
	name varchar(256),
	status char(1),
	approved boolean,
	disabled boolean,
	type char(1),
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	date_established timestamp without time zone,
	authentication_id varchar(32),
	primary_email_id varchar(32),
	primary_phone_id varchar(32)
);