FROM postgres:12
COPY ./setup-master.sh /docker-entrypoint-initdb.d/setup-master.sh
COPY ./setup-db.sh /docker-entrypoint-initdb.d/setup-db.sh
WORKDIR /tables/
COPY actors.tar.gz .
COPY basics.tar.gz .
