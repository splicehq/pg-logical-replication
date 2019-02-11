FROM postgres:11.1

# Generate an SSL certificate and key file, so that replication can be done over SSL. The postgres
# Docker image doesn't come with SSL set up, so this has to be done manually.
RUN openssl req -new -text -passout pass:abcd -subj /CN=localhost -out server.req
RUN openssl rsa -in privkey.pem -passin pass:abcd -out server.key
RUN openssl req -x509 -in server.req -text -key server.key -out server.crt

# Set permissions on the crt and key files and move them into place.
RUN chown postgres:postgres server.crt server.key
RUN chmod og-rwx server.key
RUN mkdir -p /ssl
RUN mv server.key server.crt /ssl

RUN mkdir -p /docker-entrypoint-initdb.d
COPY setup.sh /docker-entrypoint-initdb.d/setup.sh
RUN chmod +x /docker-entrypoint-initdb.d/setup.sh
