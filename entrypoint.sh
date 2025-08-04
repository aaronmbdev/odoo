#!/bin/sh

set -e

echo Waiting for database...

while ! nc -z ${ODOO_DATABASE_HOST} ${ODOO_DATABASE_PORT} 2>&1; do sleep 1; done; 

echo Database is now available

# Ensure filestore directory exists and has proper permissions
FILESTORE_DIR="/var/lib/odoo/filestore"
if [ ! -d "$FILESTORE_DIR" ]; then
    echo "Creating filestore directory..."
    mkdir -p "$FILESTORE_DIR"
fi
chown -R odoo:odoo "$FILESTORE_DIR"

ODOO_CMD="odoo \
    --http-port=\"${PORT}\" \
    --without-demo=True \
    --proxy-mode \
    --data-dir=\"/var/lib/odoo\" \
    --db_host=\"${ODOO_DATABASE_HOST}\" \
    --db_port=\"${ODOO_DATABASE_PORT}\" \
    --db_user=\"${ODOO_DATABASE_USER}\" \
    --db_password=\"${ODOO_DATABASE_PASSWORD}\" \
    --database=\"${ODOO_DATABASE_NAME}\" \
    --smtp=\"${ODOO_SMTP_HOST}\" \
    --smtp-port=\"${ODOO_SMTP_PORT_NUMBER}\" \
    --smtp-user=\"${ODOO_SMTP_USER}\" \
    --smtp-password=\"${ODOO_SMTP_PASSWORD}\" \
    --email-from=\"${ODOO_EMAIL_FROM}\""

if [ "${ODOO_INIT}" = "1" ]; then
  echo "Initializing database with modules..."
  ODOO_CMD="$ODOO_CMD --init=all"
elif [ "${ODOO_RESET}" = "1" ]; then
  echo "Resetting database completely..."
  ODOO_CMD="$ODOO_CMD --init=all --without-demo=all"
else
  echo "Skipping database initialization (ODOO_INIT is not set to 1)"
fi

eval exec $ODOO_CMD 2>&1