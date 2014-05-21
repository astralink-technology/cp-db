create table rule (
	rule_id varchar(32) primary key,
	rule_name varchar(64),
	identification varchar(32),
	type char(1),
	start_time integer,
	end_time integer,
	activity_type varchar(32),
	activity_name varchar(32),
	alert_duration integer,
	alert_trigger_interval integer,
	create_date timestamp without time zone,
	zone varchar(32),
	owner_id varchar(32)
);