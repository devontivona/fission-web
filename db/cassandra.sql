DROP KEYSPACE fission_dev;
CREATE KEYSPACE fission_dev
  WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};

USE fission_dev;

-- Triggered by client side
CREATE TABLE variation_count(
  app_id BIGINT,
  experiment_id BIGINT,
  variation_id BIGINT,

  success_count COUNTER,
  total_count COUNTER,

  PRIMARY KEY(app_id, experiment_id, variation_id)
);


-- DROP COLUMNFAMILY events;
-- Raw events
CREATE TABLE events(
  id TIMEUUID,
  app_id BIGINT,
  body TEXT,
  PRIMARY KEY(app_id, id)
);



-- -- Raw events
-- CREATE TABLE events(
--   id TIMEUUID PRIMARY KEY,
--   server_timestamp TIMESTAMP,
--   client_timestamp TIMESTAMP,
--   body TEXT,
--   status TEXT,
  
--   hour_bucket INT,
--   minute_bucket INT,
--   day_bucket INT,
--   week_bucket INT,
--   month_bucket INT,
--   year_bucket INT,

--   app_id BIGINT,
--   app_name TEXT,
--   app_access_token TEXT,
--   app_created_at TEXT,

--   client_id BIGINT,
--   client_library TEXT,
--   client_version TEXT,
--   client_manufacturer TEXT,
--   client_os TEXT,
--   client_os_version TEXT,
--   client_model TEXT,
--   client_carrier TEXT,
--   client_token TEXT,
--   client_created_at TEXT,

--   experiment_id BIGINT,
--   experiment_name TEXT,

--   variation_id BIGINT,
--   variation_name TEXT
-- );



-- -- Raw events counts
-- CREATE TABLE events_counts (
--   app_id BIGINT,
--   body TEXT,
--   count COUNTER

--   minute_bucket INT,
--   hour_bucket INT,
--   week_bucket INT,
--   day_bucket INT,
--   month_bucket INT,
--   PRIMARY KEY(app_id, month_bucket, day_bucket, week_bucket, hour_bucket, minute_bucket, body)
-- )


-- created_at [Year-Month-Week-Day-Hour-Minute]
-- CREATE TABLE events_counts (
--   app_id BIGINT,
--   body TEXT,
--   created_at TEXT,
--   metric TEXT,
--   count COUNTER,
--   PRIMARY KEY(app_id, created_at, metric, key)
-- )