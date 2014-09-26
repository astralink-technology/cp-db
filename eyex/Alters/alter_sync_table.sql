-- Alters to sync table 20140924
ALTER TABLE sync DROP COLUMN last_sync_date;
-- Alters to sync table 20140926
ALTER TABLE sync ADD COLUMN sync_pin boolean;
ALTER TABLE sync DROP COLUMN sync_sip;