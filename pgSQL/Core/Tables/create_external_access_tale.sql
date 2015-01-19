create table external_access(
      external_access_id varchar(32) primary key,
      unique_identifier varchar(32),
      owner_id varchar(32),
      enterprise_id varchar(32)
);