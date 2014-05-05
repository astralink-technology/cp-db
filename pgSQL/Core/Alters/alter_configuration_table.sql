-- Alters to configuration table 26032014
ALTER TABLE configuration
  ALTER COLUMN value TYPE varchar(128);
ALTER TABLE configuration
  ALTER COLUMN value2 TYPE varchar(128);
ALTER TABLE configuration
  ALTER COLUMN value3 TYPE varchar(128);
ALTER TABLE configuration
  ALTER COLUMN value_hash TYPE varchar(128);
ALTER TABLE configuration
  ALTER COLUMN value2_hash TYPE varchar(128);
ALTER TABLE configuration
  ALTER COLUMN value3_hash TYPE varchar(128);