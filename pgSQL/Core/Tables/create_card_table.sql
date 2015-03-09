CREATE TABLE card (
  card_id varchar(32) primary key,
  card_serial varchar(32),
  type CHAR(1),
  owner_id varchar(32)
);