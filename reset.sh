#!/bin/sh
set -e
docker rm -f master-db || true
docker rm -f slave-db || true

docker network rm mynet || true

docker rmi -f psql-12/movie-db || true

rm -rf postgres || true
rm -rf postgresslave || true