# Postgres logical replication example

This repo provides a minimal config for setting up [Postgres logical
replication][1].

This is not intended in any way to be put into production. Instead it's a
starting point for understanding how to configure logical replication and an
easy way of testing configuration changes.

## Getting started

You'll first need to install Docker if you haven't already.

Docker Compose is used to set up two containers, one acting as the publisher
(master) database instance and the second as the subscriber (replica).

To build the publisher and subscriber containers for the first time, run:

```
docker-compose build
```

You can then start the containers by running:

```
docker-compose up
```

And stop them by running:

```
docker-compose down
```

The publisher is mapped to local port 5500, and you can connect to it using `psql`:

```
psql --port 5500 --host 0.0.0.0 --user postgres
```

The subscriber is mapped to local port 5501:

```
psql --port 5501 --host 0.0.0.0 --user postgres
```

You can check the replication status by running this query on the publisher:

```
SELECT * FROM pg_stat_replication;
```

Logical replication publishes change data about each row that's inserted,
updated or deleted. It's required that the subscriber database has a compatible
schema so that it can accept changes from the publisher. In the replica setup
script, you'll see that `pg_dump` is used to grab the initial schema from the
publisher and re-create it on the subscriber.

[DDL][2] changes are **not** replicated, so any schema changes on the publisher
need to be manually applied to the subscribers for replication to continue
working.

[1]: https://www.postgresql.org/docs/11/logical-replication.html
[2]: https://www.postgresql.org/docs/current/ddl.html

## Understanding the configuration

It'll help to have some familiarity with Docker.

The `docker-compose.yml` file configures two services, `publisher` and
`subscriber`. The two containers share a network called `db` so that they can
communicate.

To understand how the `publisher` and `subscriber` containers are configured,
look at the files in the `publisher` and `subscriber` directories. There are
comments in each file to explain what's going on.
