CREATE TABLE feature (
  feature_id varchar(32) primary key
  , remote_door varchar(32)
  , local_door varchar(32)
  , extension_door varchar(32)
  , voicemail varchar(32)
  , voicemail_password varchar(32)
  , voicemail_extension varchar(32)
  , pickup varchar(32)
  , extra1 varchar(32)
  , extra2 varchar(32)
  , extra3 varchar(32)
  , extra4 varchar(32)
  , last_update timestamp without time zone
  , owner_id varchar(32)
);