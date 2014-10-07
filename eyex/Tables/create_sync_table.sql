CREATE TABLE sync (
	sync_id varchar(32) primary key,
	sync_master boolean default false,
	sync_extensions boolean default false,
	sync_profile boolean default false,
	sync_ivrs boolean default false,
	sync_pin boolean default false,
	sync_employee_profile boolean default false,
	sync_announcements boolean default false,
	create_date timestamp without time zone,
	last_update timestamp without time zone,
	owner_id varchar(32)
);