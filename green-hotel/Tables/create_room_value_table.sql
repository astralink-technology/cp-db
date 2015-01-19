CREATE TABLE room_value (
  room_value_id VARCHAR(32) PRIMARY KEY
  , name VARCHAR(128)
  , type VARCHAR(4)
  , status CHAR(1)
  , value VARCHAR(64)
  , int_value DECIMAL
);