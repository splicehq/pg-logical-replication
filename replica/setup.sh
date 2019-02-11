#!/bin/bash

set -e

SCHEMA_PATH=/var/lib/postgresql/schema.sql

createdb "$REP_DB"

wait-for-it master:5432

PGPASSWORD=rep_password pg_dump --schema-only --no-owner --no-acl --host master --dbname "$REP_DB" --username "$REP_USER" > "$SCHEMA_PATH"

psql -v ON_ERROR_STOP=1 --username="$POSTGRES_USER" --dbname "$REP_DB" < "$SCHEMA_PATH"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$REP_DB" <<EOSQL
CREATE SUBSCRIPTION $REP_SUB_NAME
CONNECTION 'host=master dbname=$REP_DB user=$REP_USER password=$REP_PASSWORD port=5432'
PUBLICATION $REP_PUB_NAME;
EOSQL