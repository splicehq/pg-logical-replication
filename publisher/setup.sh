#!/bin/bash

set -e

# The postgresql.conf file is the main config file for the PG server.
cat <<EOF >> "/etc/postgresql/postgresql.conf"
# Enable SSL.
ssl = on
ssl_cert_file = '/ssl/server.crt'
ssl_key_file = '/ssl/server.key'

# Tell the server to listen for connections on all network interfaces.
listen_addresses = '*'

# The wal_level must be set to "logical".
wal_level = logical
EOF

# Create a database that changes will be published from.
createdb "$REP_DB"

# Create a replication role with login permission. These credentials will be used to connect to the
# publisher from the subscriber instance.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<EOSQL
CREATE ROLE $REP_USER WITH REPLICATION LOGIN PASSWORD '$REP_PASSWORD';
EOSQL

# Now we'll set up a very basic schema and insert one row.
#
# Then the replication user is granted some permissions to allow it to grab the initial schema.
#
# Finally, a publication is created that publishes changes from all tables.
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
