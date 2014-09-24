CREATE TABLE extension (
	extension_id varchar(32) primary key,
	extension integer,
	extension_password varchar(128),
	last_update timestamp without time zone,
	owner_id varchar(32)
);