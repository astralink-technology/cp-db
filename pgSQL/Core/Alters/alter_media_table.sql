-- Alters to media table 20131027
ALTER TABLE media
    ALTER COLUMN status char(1);

-- Alters to media table 20131224
ALTER TABLE media
    ADD COLUMN description text;
ALTER TABLE media
    ADD COLUMN file_type varchar(16);
ALTER TABLE media
    ADD COLUMN img_url text;
ALTER TABLE media
    ADD COLUMN img_url2 text;
ALTER TABLE media
    ADD COLUMN img_url3 text;
ALTER TABLE media
    ADD COLUMN img_url4 text;

-- Alters to media table 20140107
ALTER TABLE media
    ADD COLUMN entity_id varchar(32);

-- Alters to media table 20140108
ALTER TABLE media
    ADD COLUMN filesize decimal;

-- Alters to media table 20140122
ALTER TABLE media
    RENAME COLUMN filesize TO file_size;
ALTER TABLE media
    RENAME COLUMN filename TO file_name;


-- Alters to media table 20140115
ALTER TABLE media
    DROP COLUMN entity_id;
ALTER TABLE media
    RENAME COLUMN device_id TO owner_id;