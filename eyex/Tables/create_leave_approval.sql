CREATE TABLE leave_approval (
  leave_approval_id VARCHAR(32) primary key,
  type CHAR(1),
  create_date TIMESTAMP without time zone,
  notes TEXT,
  owner_id VARCHAR(32),
  leave_id VARCHAR(32)
);