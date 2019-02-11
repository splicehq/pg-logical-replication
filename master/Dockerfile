FROM postgres:11.1

RUN mkdir -p /docker-entrypoint-initdb.d
COPY setup.sh /docker-entrypoint-initdb.d/setup.sh
RUN chmod +x /docker-entrypoint-initdb.d/setup.sh
