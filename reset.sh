#!/bin/bash
docker rm -f master-db
docker rm -f slave-db
docker rmi -f replication/psql
docker network rm mynet
rm -rf postgres
rm -rf postgresslave
