-- Alters to rule table 20140123
ALTER TABLE rule ADD COLUMN arm_state varchar(16)

-- Alters to rule table 20140629
ALTER TABLE rule
  ALTER COLUMN rule_name TYPE varchar(20)