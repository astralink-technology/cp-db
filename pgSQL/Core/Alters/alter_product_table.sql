-- Alters to product table 20131027
ALTER TABLE product
    ALTER COLUMN status char(1);

-- Alters to product table 20131103
ALTER TABLE product
    ADD COLUMN code varchar(60);
ALTER TABLE product
    ADD COlUMN type char(1);

-- Alters to product table 20140123
ALTER TABLE product
    ADD COlUMN owner_id char(32);
ALTER TABLE product
  ALTER COLUMN owner_id TYPE varchar(32);