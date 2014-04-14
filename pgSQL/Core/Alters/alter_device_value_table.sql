-- Alters to device value table 20131204
ALTER TABLE device_value
    ADD COLUMN description text;

ALTER TABLE device_value
    ADD COLUMN quality varchar(16);

ALTER TABLE device_value
    ADD COLUMN type varchar(32);

-- Alters to device value table 20131220
ALTER TABLE device_value
    ALTER COLUMN type SET DATA TYPE char(1);

-- Alters to device value table 20131223
ALTER TABLE device_value
    ALTER COLUMN type SET DATA TYPE varchar(32);

-- Alters to device value table 20131231
ALTER TABLE device_value
    ALTER COLUMN token SET DATA TYPE varchar(256);

-- Alters to device value table 20140407
ALTER TABLE device_value
    ADD COLUMN location_name varchar(64);

ALTER TABLE device_value
    ADD COLUMN latitide decimal;

ALTER TABLE device_value
    ADD COLUMN longitude decimal;

ALTER TABLE device_value
    ADD COLUMN app_version varchar(16);

ALTER TABLE device_value
    ADD COLUMN firmware_version varchar(16);
