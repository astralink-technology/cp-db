-- DROP INDEX  IF EXISTS idx_informative_analytics;
CREATE INDEX CONCURRENTLY idx_informative_analytics2 ON informative_analytics (date_value DESC, type);
CREATE INDEX CONCURRENTLY idx_informative_analytics ON informative_analytics (date_value DESC, type);