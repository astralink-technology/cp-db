-- Alters to analytics value table 20140529
ALTER TABLE analytics_value ADD COLUMN date_value3 timestamp without time zone;

-- Alters to analytics value table 20140730
ALTER TABLE analytics_value ADD COLUMN int_value3 integer;
ALTER TABLE analytics_value ADD COLUMN int_value4 integer;
ALTER TABLE analytics_value ADD COLUMN value3 varchar(32);
ALTER TABLE analytics_value ADD COLUMN value4 varchar(32);

ALTER TABLE analytics_value
  ALTER COLUMN type TYPE varchar(8)
