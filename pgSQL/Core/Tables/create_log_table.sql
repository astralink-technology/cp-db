create table log (
	log_id varchar(32) primary key, 
	message text,
	title varchar(32),
	type char(1),
	log_url text, 
	status char(1),
	create_date timestamp without time zone,
	owner_id varchar(32)
);
