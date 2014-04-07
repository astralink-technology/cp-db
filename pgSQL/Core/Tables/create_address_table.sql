create table address (
	address_id varchar(32) primary key,
	apartment varchar(64),
	road_name text,
	road_name2 text,
	suite varchar(32),
	zip varchar(16),
	country varchar(128),
	province varchar(128),
	state varchar(128),
	city varchar(128),
	type char (1),
	status char(1),
	longitude decimal,
	latitude decimal,
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	owner_id varchar(32)
);  