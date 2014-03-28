DROP KEYSPACE fission_dev;
CREATE KEYSPACE fission_dev
  WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};

USE fission_dev;

-- Triggered by client side
CREATE TABLE variations(
  app_id BIGINT,
  experiment_id BIGINT,
  variation_id BIGINT,

  success_count COUNTER,
  total_count COUNTER,

  PRIMARY KEY(app_id, experiment_id, variation_id)
);


-- Raw events counts
CREATE TABLE events_counts (
  app_id BIGINT,
  body TEXT,
  count COUNTER

  minute_bucket INT,
  hour_bucket INT,
  week_bucket INT,
  day_bucket INT,
  month_bucket INT,
  PRIMARY KEY(app_id, month_bucket, day_bucket, week_bucket, hour_bucket, minute_bucket, body)
)

-- Raw events
CREATE TABLE events(
  id TIMEUUID,
  
  hour_bucket TEXT,
  minute_bucket TEXT,
  day_bucket TEXT,
  month_bucket TEXT,

  server_timestamp TIMESTAMP,
  client_timestamp TIMESTAMP,
  body TEXT,
  status TEXT,
  
  app_id BIGINT,
  app_name TEXT,
  app_access_token TEXT,
  app_created_at TEXT,

  client_id BIGINT,
  client_library TEXT,
  client_version TEXT,
  client_manufacturer TEXT,
  client_os TEXT,
  client_os_version TEXT,
  client_model TEXT,
  client_carrier TEXT,
  client_token TEXT,
  client_created_at TEXT,

  experiment_id BIGINT,
  experiment_name TEXT,

  variation_id BIGINT,
  variation_name TEXT,
  PRIMARY KEY(app_id, id)

) WITH CLUSTERING ORDER BY (id ASC);


-- -- Aggregated events
-- CREATE TABLE session(
--   id TIMEUUID,
--   dbucket TEXT,
--   hbucket TEXT,
--   mbucket TEXT,
--   server_timestamp TIMESTAMP,
--   client_timestamp TIMESTAMP,
--   events LIST<TEXT>;
  
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

--   PRIMARY KEY(app_id, id)

-- ) WITH CLUSTERING ORDER BY (id ASC);



