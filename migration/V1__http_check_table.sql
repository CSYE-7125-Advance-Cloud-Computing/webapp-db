-- Enable uuid-ossp extension in the app schema
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA app;

-- Switch to the app schema
SET search_path TO app;

-- Create HttpCheck table
CREATE TABLE HttpCheck (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    uri VARCHAR(255) NOT NULL,
    is_paused BOOLEAN NOT NULL,
    num_retries INTEGER NOT NULL CHECK (num_retries >= 1 AND num_retries <= 5),
    uptime_sla INTEGER NOT NULL CHECK (uptime_sla >= 0 AND uptime_sla <= 100),
    response_time_sla INTEGER NOT NULL CHECK (response_time_sla >= 0 AND response_time_sla <= 100),
    use_ssl BOOLEAN NOT NULL,
    response_status_code INTEGER DEFAULT 200,
    check_interval_in_seconds INTEGER NOT NULL CHECK (check_interval_in_seconds >= 1 AND check_interval_in_seconds <= 86400),
    check_created TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    check_updated TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_status_code CHECK (response_status_code >= 100 AND response_status_code <= 599)
);
