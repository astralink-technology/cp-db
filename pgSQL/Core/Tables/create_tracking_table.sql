create table tracking (
	tracking_id varchar(32) primary key
	, name text
	, ip_address text
	, country varchar(256)
	, country_code varchar(8)
	, type varchar(4)
	, operating_system varchar(256)
	, operating_system_version varchar(256)
	, user_agent varchar(256)
	, user_agent_version varchar(256)
	, device varchar(256)
	, extra_data text
	, create_date timestamp without time zone
	, owner_id varchar(32)
);