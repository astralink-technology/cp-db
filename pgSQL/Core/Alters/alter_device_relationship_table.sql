-- Alters to device relationship table 20131226
ALTER TABLE device_relationship
    ADD COLUMN entity_id varchar(32);

ALTER TABLE device_relationship
    ADD COLUMN last_update timestamp without time zone;

-- Alters to device relationship table 20140114
ALTER TABLE device_relationship
    ADD COLUMN relationship_name varchar(64);

-- Alters to device relationship table 20140123
ALTER TABLE device_relationship
    DROP COLUMN device_2_id;
ALTER TABLE device_relationship
    RENAME COLUMN entity_id to owner_id;
ALTER TABLE device_relationship
    DROP COLUMN relationship_name;

-- Alters to device relationship table 20140407
ALTER TABLE device_relationship
    ADD COLUMN app_name varchar(64);

-- Alters to device relationship table 20150106
ALTER TABLE device_relationship
    ADD COLUMN authorize char(1);
