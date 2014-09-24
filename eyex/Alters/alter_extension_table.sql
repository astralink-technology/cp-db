-- Alters to extension table 20140924
ALTER TABLE extension ADD COLUMN create_date timestamp without time zone;
ALTER TABLE extension ADD COLUMN extension_password varchar(128);