#!/bin/sh

docker rm -f master-db
docker rm -f slave-db

docker network rm mynet

docker rmi -f psql-12/movie-db:${BUILD_NUMBER}
docker rmi -f psql-12/movie-db:latest

rm -rf postgres
rm -rf postgresslave
