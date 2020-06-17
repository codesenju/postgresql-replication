#!/bin/bash
pg_restore -d movie /tables/actors.tar.gz
pg_restore -d movie /tables/basics.tar.gz
