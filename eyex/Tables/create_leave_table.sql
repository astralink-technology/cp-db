CREATE TABLE leave (
  leave_id VARCHAR(32) primary key,
  type CHAR(1),
  create_date TIMESTAMP without time zone,
  leave_start TIMESTAMP without time zone,
  leave_end TIMESTAMP without time zone,
  leave_count DECIMAL,
  notes TEXT,
  owner_id VARCHAR(32)
);