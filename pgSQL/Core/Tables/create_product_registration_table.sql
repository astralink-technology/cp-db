create table product_registration (
	product_registration_id varchar(32) primary key,
	status char(1),
  type char (1),
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	product_id varchar(32),
	owner_id varchar(32)
);