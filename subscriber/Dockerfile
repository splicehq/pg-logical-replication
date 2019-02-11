FROM postgres:11.1

# Install the wait-for-it package, which will be used in the setup script.
RUN apt-get update -y
RUN apt-get install -y wait-for-it

# Copy the setup.sh script to the container. The postgres Docker image is set up so that any scripts
# in the docker-entrypoint-initdb.d directory will be run after the database is initialized.
RUN mkdir -p /docker-entrypoint-initdb.d
COPY setup.sh /docker-entrypoint-initdb.d/setup.sh
RUN chmod +x /docker-entrypoint-initdb.d/setup.sh
