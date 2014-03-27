DROP KEYSPACE fission_dev;
CREATE KEYSPACE fission_dev
  WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};

USE fission_dev;

CREATE TABLE events(
  id TIMEUUID,
  created_at TIMESTAMP,
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