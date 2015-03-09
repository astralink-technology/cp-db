-- core
CREATE INDEX CONCURRENTLY idx_entity ON entity(first_name, last_name, name);
CREATE INDEX CONCURRENTLY idx_authentication ON authentication(authorization_level, authentication_string_lower);
CREATE INDEX CONCURRENTLY idx_device ON device(type, deployment_date, create_date);

-- lifecare
CREATE INDEX CONCURRENTLY idx_informative_analytics ON informative_analytics(create_date, date_value, type);
CREATE INDEX CONCURRENTLY idx_eyecare ON eyecare(create_date, event_type_id, eyecare_id, zone_code);
