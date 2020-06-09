#!/bin/bash
docker exec -it master-db /bin/bash -c 'pg_basebackup -h master-db -U replicator -p 5432 -D /tmp/postgresslave -Fp -Xs -P -Rv' 
docker cp master-db:/tmp/postgresslave /$PWD/
