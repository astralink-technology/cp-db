create table email (
	email_id varchar(32) primary key, 
	email_address varchar(64), 
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	owner_id varchar(32)
);
