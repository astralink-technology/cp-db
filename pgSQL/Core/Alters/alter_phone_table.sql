-- Alters to phone table 20131216
ALTER TABLE phone
    ADD COLUMN device_id varchar(32);

-- Alters to phone table 20131219
ALTER TABLE phone
    ADD COLUMN digits varchar(32);

ALTER TABLE phone
    ALTER COLUMN country_code SET DATA TYPE varchar(4);
ALTER TABLE phone
    ALTER COLUMN code SET DATA TYPE varchar(8);


-- Alters to phone table 20140115
ALTER TABLE phone
    DROP COLUMN entity_id;
ALTER TABLE phone
    RENAME COLUMN device_id TO owner_id;