CREATE TABLE cloud_access (
	cloud_access_id varchar(32) primary key,
	local_cloud_access_id varchar(32),
	secret varchar(32),
	type varchar(4),
	token text,
  extra_data text,
  extra_date_time timestamp without time zone,
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	owner_id varchar(32)
);