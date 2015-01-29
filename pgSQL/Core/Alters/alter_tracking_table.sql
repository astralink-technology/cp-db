-- Alters to tracking table 2015-01-29
ALTER TABLE tracking ADD COLUMN country varchar(256);
ALTER TABLE tracking ADD COLUMN country_code varchar(8);
ALTER TABLE tracking ADD COLUMN operating_system varchar(256);
ALTER TABLE tracking ADD COLUMN operating_system_version varchar(256);
ALTER TABLE tracking ADD COLUMN user_agent varchar(256);
ALTER TABLE tracking ADD COLUMN user_agent_version varchar(256);
ALTER TABLE tracking ADD COLUMN device varchar(256);
ALTER TABLE tracking ADD COLUMN extra_data text;