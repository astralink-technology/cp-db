-- Alters to device relationship table 20140124
ALTER TABLE device_relationship_value
    ALTER COLUMN type TYPE char(1);

-- Alters to device relationship table 20140407
ALTER TABLE device_relationship_value
    ADD COLUMN app_version varchar(16);

ALTER TABLE device_relationship_value
    ADD COLUMN firmware_version varchar(16);

ALTER TABLE device_relationship_value
    DROP COLUMN app_version;

ALTER TABLE device_relationship_value
    DROP COLUMN firmware_version;
