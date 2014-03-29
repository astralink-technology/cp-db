create table image (
	image_id varchar(32) primary key,
	title varchar(32),
	type char(1),
  file_name text,
	img_url text,
	status char(1),
	description text,
	file_type varchar(16),
	file_size decimal,
	create_date timestamp without time zone,
	owner_id varchar(32)
);
