-- Alters to device value table 20140117
ALTER TABLE message
    ADD COLUMN trigger_event char(2);
ALTER TABLE message
    ADD COLUMN subject varchar(128);



