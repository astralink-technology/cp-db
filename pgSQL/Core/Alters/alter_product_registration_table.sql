-- Alters to product registration table 20131205
ALTER TABLE product_registration
    ADD COLUMN create_date timestamp without time zone

ALTER TABLE product_registration
    ADD COLUMN last_update timestamp without time zone

-- Alters to product registration table 20140123
ALTER TABLE product_registration
    RENAME COLUMN entity_id TO owner_id
