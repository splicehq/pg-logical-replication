#!/bin/bash

set -e

createdb "$REP_DB"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<EOSQL
CREATE ROLE $REP_USER WITH REPLICATION LOGIN PASSWORD '$REP_PASSWORD';
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$REP_DB" <<EOSQL
CREATE TABLE users (
  id serial primary key,
  name text not null,
  color text not null default 'blue'
);

INSERT INTO users (name, color) VALUES ('nick', 'green');

GRANT CONNECT ON DATABASE $REP_DB TO $REP_USER;
GRANT USAGE ON SCHEMA public TO $REP_USER;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO $REP_USER;

CREATE PUBLICATION $REP_PUB_NAME FOR ALL TABLES;
EOSQL
