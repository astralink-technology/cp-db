-- Alters to informative analytics value table 20140702
ALTER TABLE informative_analytics
  ALTER COLUMN type TYPE varchar(8)

-- Alters to informative value table 2015-01-27
ALTER TABLE informative_analytics ADD COLUMN entity_id varchar(32);
