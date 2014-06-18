create table entity_relationship (
	entity_relationship_id varchar(32) primary key, 
	entity_id varchar(32), 
	related_id varchar(32),
	status char(1),
	type char(1),
	create_date timestamp without time zone
);
