CREATE TABLE sip (
	sip_id varchar(32) primary key,
	sip_host varchar(256),
	sip_password varchar(128),
	last_update timestamp without time zone,
	owner_id varchar(32)
);