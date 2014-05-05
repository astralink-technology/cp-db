create table phone (
	phone_id varchar(32) primary key, 
	digits varchar(32),
	phone_digits varchar(32),
	country_code varchar(4),
	code varchar(8),
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	owner_id varchar(32)
);
