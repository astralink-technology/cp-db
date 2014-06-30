-- Alters to message table 20140117
ALTER TABLE message
    ADD COLUMN trigger_event char(2);
ALTER TABLE message
    ADD COLUMN subject varchar(128);

-- Alters to the message table 20140628
ALTER TABLE message
  ADD COLUMN status char(1)