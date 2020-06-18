#!/usr/bin/env bash
# configure postgresql for real-time replication
psql -U postgres -c "CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'passw0rd';" && \
psql -U postgres -c "ALTER SYSTEM SET listen_addresses TO '*'" && \
psql -U postgres -c "alter system set wal_level = replica ;" && \
psql -U postgres -c "alter system set max_wal_senders = 18;" && \
psql -U postgres -c "alter system set hot_standby = on;" && \
psql -U postgres -c "alter system set promote_trigger_file='promote.signal'" && \
echo host replication replicator 0.0.0.0/0 trust >> "$PGDATA/pg_hba.conf"
echo "User Replicator added!"

