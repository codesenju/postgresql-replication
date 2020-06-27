#!/bin/sh
rm -rf postgres
rm -rf postgresslave
docker rm -f master-db
docker rm -f slave-db
docker rmi -f psql-12/movie-db
docker network rm mynet

