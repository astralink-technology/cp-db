create table rule (
	rule_id varchar(32) primary key,
	identification varchar(32),
	type char(1),
	start_time time without time zone,
	end_time time without time zone,
	activity_type varchar(32),
	activity_name varchar(32),
	alert_trigger_time time without time zone,
	alert_trigger_interval interval,
	zone varchar(32),
	owner_id varchar(32)
);