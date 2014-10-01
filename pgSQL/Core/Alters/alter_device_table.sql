-- Alters to device table 20131027
ALTER TABLE device
    ALTER COLUMN status char(1);

-- Alters to device table 20131127
ALTER TABLE device
    ADD COLUMN description text;

-- Alters to device table 20131204
ALTER TABLE device
    DROP COLUMN device_value_id

-- Alters to device table 20140123
ALTER TABLE device
    RENAME COLUMN entity_id TO owner_id

-- Alters to device table 20140621
ALTER TABLE device
    ADD COLUMN deployment_date date