#!/bin/bash

# Create the user that will contain the configuration for Huginn
#adduser huginn
#usermod -aG sudo huginn

# Create the volume used to store the custom scripts used with 
# the shell agent in Huginn
mkdir /opt/scripts
# todo: Move the contents of ./scripts to /opt/scripts

# Traefik needs a file to store SSL/TLS keys and certificates.
touch ./acme.json
chmod 0600 ./acme.json

# Stage the .env template file for modification
cp .env-template .env

# Use the hostname of the server as the main domain.
sed -i -e "s|^TRAEFIK_DOMAINS=.*|TRAEFIK_DOMAINS=`hostname -f`|" .env
sed -i -e "s|^HUGINN_DOMAINS=.*|HUGINN_DOMAINS=`hostname -f`|" .env
sed -i -e "s|^HUGINN_EMAIL=.*|HUGINN_EMAIL=huginn@`hostname -f`|" .env
  
# Fill /$COMPOSE_DIR/.env with some randomly generated passwords.
sed -i -e "s|^HUGINN_DB_ROOT_PASSWORD=.*|HUGINN_DB_ROOT_PASSWORD=`cat /dev/urandom | tr -dc '[:alnum:]' | head -c14`|" .env
sed -i -e "s|^HUGINN_DB_PASSWORD=.*|HUGINN_DB_PASSWORD=`cat /dev/urandom | tr -dc '[:alnum:]' | head -c14`|" .env
sed -i -e "s|^HUGINN_ADMIN_PASSWORD=.*|HUGINN_ADMIN_PASSWORD=`cat /dev/urandom | tr -dc '[:alnum:]' | head -c14`|" .env
sed -i -e "s|^HUGINN_INVITATION_CODE=.*|HUGINN_INVITATION_CODE=`cat /dev/urandom | tr -dc '[:alnum:]' | head -c14`|" .env

apt-get install -y apache2-utils
BASIC_AUTH_PASSWORD="`cat /dev/urandom | tr -dc '[:alnum:]' | head -c10`"
BASIC_AUTH="`printf '%s\n' "$BASIC_AUTH_PASSWORD" | tee ./auth-password.txt | htpasswd -in admin`"
sed -i -e "s|^BASIC_AUTH=.*|BASIC_AUTH=$BASIC_AUTH|" .env

# Start up the containers
docker-compose up -d