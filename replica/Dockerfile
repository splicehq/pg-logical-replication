FROM postgres:11.1

# Install the wait-for-it package, which will be used in the setup script.
RUN apt-get update -y
RUN apt-get install -y wait-for-it

RUN mkdir -p /docker-entrypoint-initdb.d
COPY setup.sh /docker-entrypoint-initdb.d/setup.sh
RUN chmod +x /docker-entrypoint-initdb.d/setup.sh
