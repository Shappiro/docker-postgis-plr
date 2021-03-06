#!/usr/bin/env bash

DATADIR="/var/lib/postgresql/11/main"
ROOT_CONF="/etc/postgresql/11/main"
CONF="$ROOT_CONF/postgresql.conf"
WAL_ARCHIVE="/opt/archivedir"
RECOVERY_CONF="$ROOT_CONF/recovery.conf"
POSTGRES="/usr/lib/postgresql/11/bin/postgres"
INITDB="/usr/lib/postgresql/11/bin/initdb"
SQLDIR="/usr/share/postgresql/11/contrib/postgis-2.5/"
SETVARS="POSTGIS_ENABLE_OUTDB_RASTERS=1 POSTGIS_GDAL_ENABLED_DRIVERS=ENABLE_ALL"
LOCALONLY="-c listen_addresses='127.0.0.1'"
PG_BASEBACKUP="/usr/bin/pg_basebackup"
PROMOTE_FILE="/tmp/pg_promote_master"
PGSTAT_TMP="/var/run/postgresql/"
PG_PID="/var/run/postgresql/11-main.pid"

# Make sure we have a user set up
if [ -z "${POSTGRES_USER}" ]; then
	POSTGRES_USER=docker
fi
if [ -z "${POSTGRES_PASS}" ]; then
	POSTGRES_PASS=docker
fi
if [ -z "${POSTGRES_PORT}" ]; then
	POSTGRES_PORT=5433
fi
if [ -z "${POSTGRES_DBNAME}" ]; then
	POSTGRES_DBNAME=gis
fi
# SSL mode
if [ -z "${PGSSLMODE}" ]; then
	PGSSLMODE=require
fi
# Enable hstore, topology and R by default
if [ -z "${HSTORE}" ]; then
	HSTORE=true
fi
if [ -z "${TOPOLOGY}" ]; then
	TOPOLOGY=true
fi
if [ -z "${R}" ]; then
	R=true
fi

if [ -z "${IP_LIST}" ]; then
	IP_LIST='*'
fi

if [ -z "${POSTGRES_MULTIPLE_EXTENSIONS}" ]; then
  POSTGRES_MULTIPLE_EXTENSIONS='postgis,hstore,postgis_topology,plr'
fi
# Compatibility with official postgres variable
# Official postgres variable gets priority
if [ ! -z "${POSTGRES_PASSWORD}" ]; then
	POSTGRES_PASS=${POSTGRES_PASSWORD}
fi
if [ ! -z "${PGDATA}" ]; then
	DATADIR=${PGDATA}
fi

if [ ! -z "$POSTGRES_DB" ]; then
	POSTGRES_DBNAME=${POSTGRES_DB}
fi
