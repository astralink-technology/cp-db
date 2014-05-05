create table authentication (
	authentication_id varchar(32) primary key, 
	authentication_string varchar(64), 
	authentication_string_lower varchar(64),
	hash varchar(60),
	salt varchar(16),
	last_login timestamp without time zone,
	last_logout timestamp without time zone,
	last_change_password timestamp without time zone,
	request_authentication_start timestamp without time zone,
	request_authentication_end timestamp without time zone,
	authorization_level int default 100,
	create_date timestamp without time zone,
	last_update timestamp without time zone
);