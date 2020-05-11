#!/bin/bash

docker network create test
echo "Created network 'test'"

docker run --name master-db -d -p 15432:5432 --net test -e POSTGRES_DB=test -e POSTGRES_HOST_AUTH_METHOD=trust -e POSTGRES_USER=postgres -v /$PWD/postgres:/var/lib/postgresql/data postgres:latest
sleep 10
echo "master-db container running on port 15432"

# wait 20 seconds
echo "wait 20 sec…"
sleep 10 && echo "loading…" && sleep 10

echo "Editing the general configuration files:"
docker exec -it master-db psql -U postgres -c "CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'passw0rd';"

docker exec -it master-db psql -U postgres -c "ALTER SYSTEM SET listen_addresses TO '*'"
echo host replication replicator 0.0.0.0/0 trust >> /$PWD/postgres/pg_hba.conf

docker exec -it master-db psql -U postgres -c "alter system set wal_level = replica ;" && \
docker exec -it master-db psql -U postgres -c "alter system set max_wal_senders = 16;" && \
docker exec -it master-db psql -U postgres -c "alter system set hot_standby = on;"

docker exec -it master-db psql -U postgres -c "select pg_reload_conf()"

# wait 8 seconds
sleep 4 && echo "we're almost there..." && sleep 4

echo "master-db setup complete."
sleep 2
echo "now setting up replica-db."
docker exec -it master-db /bin/bash -c 'pg_basebackup -h master-db -U replicator -p 5432 -D /tmp/postgresslave -Fp -Xs -P -Rv'

docker cp master-db:/tmp/postgresslave /$PWD/

echo "setting up replica-db"
docker run --name replica-db -d -p 15433:5432 -e POSTGRES_DB=test -e POSTGRES_HOST_AUTH_METHOD=trust -e POSTGRES_USER=postgres -v /$PWD/postgresslave:/var/lib/postgresql/data --net test postgres:latest

sleep 2
echo "replica-db container running on port 15433"

#TEST
sleep 2
echo "Checking health…"
sleep 10
docker exec -it master-db psql -U postgres -c 'select * from pg_stat_replication;'
