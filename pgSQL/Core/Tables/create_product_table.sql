create table product (
	product_id varchar(32) primary key,
	name varchar(32),
	description text,
	code varchar (60),
  type char (1),
  status char(1),
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	owner_id varchar(32)
);