#!/bin/bash
docker network create test
echo "Created network 'test'"
docker build -t replication/psql .
docker run --name master-db -d -p 15432:5432 --net test -e POSTGRES_DB=test -e POSTGRES_HOST_AUTH_METHOD=trust -v /$PWD/postgres:/var/lib/postgresql/data replication/psql
sleep 5
echo "master-db container running on port 15432"
sleep 6
echo "Wait 24 seconds..."
sleep 12 && echo "Loading..." && sleep 12
echo "Starting backup"
sleep 5
docker exec -it master-db /bin/bash -c 'pg_basebackup -h master-db -U replicator -p 5432 -D /tmp/postgresslave -Fp -Xs -P -Rv' 
docker cp master-db:/tmp/postgresslave /$PWD/ # copy backup data to current directory
docker run --name replica-db -d -p 15433:5432 -e POSTGRES_DB=test -e POSTGRES_HOST_AUTH_METHOD=trust -v /$PWD/postgresslave:/var/lib/postgresql/data --net test replication/psql
sleep 5
echo "replica-db container running on port 15433"
# TEST
sleep 5
echo "Checking health…"
sleep 10
docker exec -it master-db psql -U postgres -c 'select * from pg_stat_replication;'
sleep 1
echo "Setup is complete"
