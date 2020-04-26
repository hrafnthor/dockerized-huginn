
#!/bin/bash

# Create the user that will contain the configuration for Huginn
#adduser huginn
#usermod -aG sudo huginn

# Create the directory that will contain all the relevant configs
COMPOSE_DIR="./compose"
mkdir -p $COMPOSE_DIR

# Traefik needs a file to store SSL/TLS keys and certificates.
touch $COMPOSE_DIR/acme.json
chmod 0600 $COMPOSE_DIR/acme.json
   
ENV_FILE=$COMPOSE_DIR/.env   

# Use the hostname of the server as the main domain.
sed -i -e "s|^TRAEFIK_DOMAINS=.*|TRAEFIK_DOMAINS=`hostname -f`|" $ENV_FILE
sed -i -e "s|^HUGINN_DOMAINS=.*|HUGINN_DOMAINS=`hostname -f`|" $ENV_FILE
sed -i -e "s|^HUGINN_EMAIL=.*|HUGINN_EMAIL=huginn@`hostname -f`|" $ENV_FILE
  
# Fill /$COMPOSE_DIR/.env with some randomly generated passwords.
sed -i -e "s|^HUGINN_DB_ROOT_PASSWORD=.*|HUGINN_DB_ROOT_PASSWORD=`cat /dev/urandom | tr -dc '[:alnum:]' | head -c14`|" $ENV_FILE
sed -i -e "s|^HUGINN_DB_PASSWORD=.*|HUGINN_DB_PASSWORD=`cat /dev/urandom | tr -dc '[:alnum:]' | head -c14`|" $ENV_FILE
sed -i -e "s|^HUGINN_ADMIN_PASSWORD=.*|HUGINN_ADMIN_PASSWORD=`cat /dev/urandom | tr -dc '[:alnum:]' | head -c14`|" $ENV_FILE
sed -i -e "s|^HUGINN_INVITATION_CODE=.*|HUGINN_INVITATION_CODE=`cat /dev/urandom | tr -dc '[:alnum:]' | head -c14`|" $ENV_FILE

apt-get install -y apache2-utils
BASIC_AUTH_PASSWORD="`cat /dev/urandom | tr -dc '[:alnum:]' | head -c10`"
BASIC_AUTH="`printf '%s\n' "$BASIC_AUTH_PASSWORD" | tee /root/compose/auth-password.txt | htpasswd -in admin`"
sed -i -e "s|^BASIC_AUTH=.*|BASIC_AUTH=$BASIC_AUTH|" $ENV_FILE

# Start up the containers
cd $COMPOSE_DIR
docker-compose up -d