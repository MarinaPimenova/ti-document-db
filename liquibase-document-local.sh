#!/usr/bin/env bash


set -ex

DB_ADDRESS="${DB_ADDRESS:-ti-document-db:5432}"
DB_PASSWORD="${DB_PASSWORD:-postgres}"
DB_USERNAME="${DB_USERNAME:-postgres}"

export PGPASSWORD="${DB_PASSWORD}"
# psql -h ${DB_ADDRESS} -U ${DB_username} -d document_db -tc "CREATE SCHEMA IF NOT EXISTS document AUTHORIZATION document_user;"
 docker run --rm \
 --network knowledge-network \
 -v ./resources/liquibase:/liquibase/changelog \
  mnpma/liquibase-pg:5.0 \
 --url=jdbc:postgresql://ti-document-db:5432/document_db \
  --username=${DB_USERNAME} \
  --password=${DB_PASSWORD} \
 --changeLogFile=liquibase-changelog.xml \
 --contexts=dev \
 update