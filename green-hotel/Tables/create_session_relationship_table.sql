CREATE TABLE session_relationship (
  session_relationship_id VARCHAR(32) PRIMARY KEY
  , session_id VARCHAR(32)
  , owner_id VARCHAR(32)
  , type VARCHAR(4)
  , status CHAR(1)
);