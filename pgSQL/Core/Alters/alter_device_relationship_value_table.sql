-- Alters to device relationship table 20140124
ALTER TABLE device_relationship_value
    ALTER COLUMN type TYPE char(1);