-- Alters to log value table 20140106
ALTER TABLE log
    ADD COLUMN device_code varchar(32);

-- Alters to log table 20140115
ALTER TABLE log
    DROP COLUMN device_code;

-- Alters to log table 20140115
ALTER TABLE log
    DROP COLUMN device_code;

-- Alters to log table 20140115
ALTER TABLE log
    DROP COLUMN entity_id;
ALTER TABLE log
    RENAME COLUMN device_id TO owner_id;

-- Alters to log table 20140123
ALTER TABLE log
  ALTER COLUMN type TYPE char(1);

-- Alters to log table 20140407
ALTER TABLE log
    ADD COLUMN snapshot_value1 varchar(16);

ALTER TABLE log
    ADD COLUMN snapshot_value2 varchar(16);
