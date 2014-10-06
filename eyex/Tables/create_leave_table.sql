CREATE TABLE leave(
	leave_id varchar(32) primary key,
	name varchar(64),
	type char(1),
	date_start timestamp without time zone,
	date_end timestamp without time zone,
	create_date timestamp without taime zone,
	last_update timestamp without time zone,
	owner_id varchar(32)
);