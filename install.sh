#!/bin/bash
docker network create mynet
echo "Created network 'mynet'"
docker build -t psql-12/movie-db .
sleep 1
echo "Spinning up master-db container"
docker run --name master-db -d -p 15432:5432 --net mynet -e POSTGRES_DB=movie -e POSTGRES_HOST_AUTH_METHOD=trust -v /$PWD/postgres:/var/lib/postgresql/data psql-12/movie-db
sleep 15
echo "master-db container running on port 15432"
sleep 15
echo "Wait for a few minutes..."
sleep 10 && echo "Populating tables with movie data" && sleep 10 && echo "Loading..." && sleep 10
echo "Starting backup"
echo -ne '###                        (16%)\r'
sleep 25
echo -ne '######                     (33%)\r'
sleep 25
echo -ne '##########                 (49%)\r'
sleep 25
echo -ne '#############              (65%)\r'
sleep 25
echo -ne '###############            (81%)\r'
sleep 25
echo -ne '###################        (89%)\r'
sleep 25
echo -ne '#######################    (97%)\r'
sleep 25
echo -ne '########################## (100%)\r'
echo -ne '\n'
docker exec -it master-db /bin/bash -c 'pg_basebackup -h master-db -U replicator -p 5432 -D /tmp/postgresslave -Fp -Xs -P -Rv' 
sleep 5
echo "Backup complete!"
docker cp master-db:/tmp/postgresslave /$PWD/ # copy backup data to current directory
sleep 5
docker run --name slave-db -d -p 15433:5432 -e POSTGRES_DB=movie -e POSTGRES_HOST_AUTH_METHOD=trust -v /$PWD/postgresslave:/var/lib/postgresql/data --net mynet psql-12/movie-db
sleep 5
echo "slave-db container running on port 15433"
# TEST
sleep 5
echo "Checking health…"
sleep 5
docker exec -it master-db psql -U postgres \
-c 'select client_addr As slave_db_ip, state, sync_state, reply_time from pg_stat_replication;'
sleep 1
echo "Setup is complete"