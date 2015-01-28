create table enterprise_relationship(
      enterprise_relationship_id varchar(32) primary key,
      enterprise_id varchar(32),
      external_unique_identifier varchar(32),
      owner_id varchar(32),
      status char(1),
      type varchar(4),
      create_date timestamp without time zone,
      last_update timestamp without time zone
);