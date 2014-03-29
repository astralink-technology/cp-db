create table device_session (
	device_id varchar(32), 
	connected_device_id varchar(32), 
	status char(1),
	create_date timestamp without time zone
);
