FROM postgres:latest
COPY ./setup-master.sh /docker-entrypoint-initdb.d/setup-master.sh
