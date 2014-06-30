create table message_read(
	message_read_id varchar(32) primary key
	, message_id varchar(32)
	, reader_id varchar(32)
	, status char(1)
	, create_date timestamp without time zone
)