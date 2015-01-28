create table tracking (
	tracking_id varchar(32) primary key
	, name text
	, ip_address text
	, country varchar(256)
	, country_code varchar(8)
	, type varchar(4)
	, create_date timestamp without time zone
	, owner_id varchar(32)
);