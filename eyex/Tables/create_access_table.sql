CREATE TABLE access (
	access_id varchar(32) primary key,
	pin varchar(8),
	card_id text,
	create_date timestamp without time zone,
	owner_id varchar(32)
);