#!/bin/bash
# pg_restore is a utility for restoring a PostgreSQL database from an archive created by pg_dump
# Here we are restoring tables that have records of movie titles(basics.tar.gz) and actors(actors.tar.gz)
pg_restore -d movie /tables/actors.tar.gz
pg_restore -d movie /tables/basics.tar.gz
