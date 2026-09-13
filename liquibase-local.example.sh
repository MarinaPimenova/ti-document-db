#!/usr/bin/env bash

set -ex

DB_ADDRESS=<see service name in docker-compose.yml>
DB_PASSWORD=postgres
DB_USERNAME=postgres

export PGPASSWORD="${DB_PASSWORD}"
# psql -h ${DB_ADDRESS} -U ${DB_username} -d document_db -tc "CREATE SCHEMA IF NOT EXISTS document AUTHORIZATION document_user;"
docker run --rm -v ./resources/liquibase:/liquibase/changelog \
  mnpma/liquibase-pg:5.0 \
 --url=jdbc:postgresql://${BD_ADDRESS}:5432/document_db \
  --username=${DB_USERNAME} \
  --password=${DB_PASSWORD} \
  --changeLogFile=liquibase-changelog.xml \
  --contexts=dev \
  update

# or one more possible case to run:
CONTAINER_NAME=
NETWORK=knowledge-network
 docker run --rm \
 --network ${NETWORK} \
 -v ./resources/liquibase:/liquibase/changelog \
  mnpma/liquibase-pg:5.0 \
 --url=jdbc:postgresql://${CONTAINER_NAME}:5433/document_db \
  --username=${DB_username} \
  --password=${DB_PASSWORD} \
 --changeLogFile=liquibase-changelog.xml \
 --contexts=dev \
 update