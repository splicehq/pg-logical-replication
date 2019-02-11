#!/bin/bash

set -e

SCHEMA_PATH=/var/lib/postgresql/schema.sql

# Create a database that will receive changes from the publisher.
createdb "$REP_DB"

# Wait for the publisher database server to become available on port 5432.
wait-for-it publisher:5432

# Grab the schema from the publisher using pg_dump.
PGPASSWORD=rep_password pg_dump --schema-only --no-owner --no-acl --host publisher --dbname "$REP_DB" \
  --username "$REP_USER" > "$SCHEMA_PATH"

# Apply the schema to the local database.
psql -v ON_ERROR_STOP=1 --username="$POSTGRES_USER" --dbname "$REP_DB" < "$SCHEMA_PATH"

# Finally, create a subscription. The subscriber will now start receiving changes from the
# publisher.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$REP_DB" <<EOSQL
CREATE SUBSCRIPTION $REP_SUB_NAME
CONNECTION 'host=publisher dbname=$REP_DB user=$REP_USER password=$REP_PASSWORD port=5432 sslmode=require'
PUBLICATION $REP_PUB_NAME;
EOSQL
