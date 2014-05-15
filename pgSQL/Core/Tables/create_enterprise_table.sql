create table enterprise(
      enterprise_id varchar(32) primary key,
      name varchar(32),
      code varchar(64),
      description text,
      create_date timestamp without time zone,
      last_update timestamp without time zone
);