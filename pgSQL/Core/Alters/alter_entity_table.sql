-- Alters to entity table 2014-06-16
ALTER TABLE entity ADD COLUMN date_established timestamp without time zone

-- Alters to entity table 2014-06-18
ALTER TABLE entity ADD COLUMN location_name varchar(128);

-- Alters to entity table 2014-07-22
ALTER TABLE entity ADD COLUMN disabled boolean;

-- Alters to entity table 2015-01-12
ALTER TABLE entity
  ALTER COLUMN nick_name TYPE varchar(256);
ALTER TABLE entity
  ALTER COLUMN name TYPE varchar(256);
ALTER TABLE entity
  ALTER COLUMN first_name TYPE varchar(128);
ALTER TABLE entity
  ALTER COLUMN last_name TYPE varchar(128);