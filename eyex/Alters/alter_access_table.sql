-- Alters to access table 20140920
ALTER TABLE access ADD COLUMN extension integer
ALTER TABLE access DROP COLUMN extension;
ALTER TABLE access ADD COLUMN extension_id varchar(32);
ALTER TABLE access ADD COLUMN last_update timestamp without time zone;