-- Alters to entity table 2014-06-16
ALTER TABLE entity ADD COLUMN date_established timestamp without time zone

-- Alters to entity table 2014-06-18
ALTER TABLE entity ADD COLUMN location_name varchar(128);