create table configuration (
      configuration_id varchar(32) primary key,
      name varchar(64),
      file_url text,
      value varchar(128),
      value2 varchar(128),
      value3 varchar(128),
      value_hash varchar(128),
      value2_hash varchar(128),
      value3_hash varchar(128),
      description text,
	    type char(1),
      enterprise_id varchar(32),
      create_date timestamp without time zone,
      last_update timestamp without time zone
);