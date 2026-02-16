-- Pre-create extensions before any Flyway migrations run.
-- This avoids the race condition where multiple migration containers
-- concurrently attempt CREATE EXTENSION IF NOT EXISTS on the same database.
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
