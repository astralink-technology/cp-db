CREATE TABLE access (
	sync_id varchar(32) primary key,
	sync boolean,
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	last_sync_date timestamp without time zone,
	owner_id varchar(32)
);