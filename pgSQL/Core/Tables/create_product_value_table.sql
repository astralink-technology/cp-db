create table product_value (
	product_value_id varchar(32) primary key,
	product_value_name varchar(256), 
	value decimal, 
	value2 decimal,
	value3 decimal,
	value_unit varchar(32),
	status char(1),
	type char(1),
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	product_id varchar(32)
);