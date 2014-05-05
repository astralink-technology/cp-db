-- Alters to authentication table 20131020
ALTER TABLE authentication ADD COLUMN request_authentication_start timestamp without time zone;
ALTER TABLE authentication ADD COLUMN request_authentication_end timestamp without time zone;

-- Alters to authentication table 20131022
ALTER TABLE authentication ADD COLUMN authorization_level int default 100;