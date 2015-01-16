CREATE TABLE session (
  session_id VARCHAR(32) PRIMARY KEY
  , start_date TIMESTAMP WITHOUT TIME ZONE
  , end_date TIMESTAMP WITHOUT TIME ZONE
  , create_date TIMESTAMP WITHOUT TIME ZONE
  , type VARCHAR(4)
  , status CHAR(1)
  , value VARCHAR(32)
  , value2 VARCHAR(32)
  , value3 VARCHAR(32)
  , int_value DECIMAL
  , int_value2 DECIMAL
  , int_value3 DECIMAL
  , owner_id VARCHAR(32)
  , object_id VARCHAR(32)
);