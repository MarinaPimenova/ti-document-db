#!/usr/bin/env bash

# /mnt/c/Users/MarinaPimenova/sb-projects

set -ex

##echo "contextEnv: ${contextEnv}"
##DB_ADDRESS=jdbc:postgresql://localhost:5433/document_db
# url=jdbc:postgresql://host.docker.internal:5433/document_db
# DB_ADDRESS=
DB_PASSWORD=postgres
DB_username=postgres

export PGPASSWORD="${DB_PASSWORD}"
# psql -h ${DB_ADDRESS} -U ${DB_username} -d document_db -tc "CREATE SCHEMA IF NOT EXISTS document AUTHORIZATION document_user;"
 docker run --rm \
 --network knowledge-network \
 -v ./resources/liquibase:/liquibase/changelog \
 liquibase-pg:latest \
 --url=jdbc:postgresql://ti-document-db:5432/document_db \
 --username=postgres \
 --password=postgres \
 --changeLogFile=liquibase-changelog.xml \
 --contexts=dev \
 update