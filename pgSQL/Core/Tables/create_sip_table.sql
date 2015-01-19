create table sip (
	sip_id varchar(32) primary key
	, username varchar(128)
	, password text
	, create_date timestamp without time zone
	, last_update timestamp without time zone
	, owner_id varchar(32)
);