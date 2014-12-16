create table media (
	media_id varchar(32) primary key, 
	title varchar(32),
	type char(1),
  file_name text,
	media_url text, 
	status char(1),
	description text,
	file_type varchar(16),
	img_url text,
	img_url2 text,
	img_url3 text,
	img_url4 text,
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	owner_id varchar(32),
	file_size decimal
);
