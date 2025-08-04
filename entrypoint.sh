#!/bin/sh

set -e

echo "Waiting for database..."

while ! nc -z ${ODOO_DATABASE_HOST} ${ODOO_DATABASE_PORT} 2>&1; do sleep 1; done; 

echo "Database is now available"

# Handle Railway volume mounting and permissions
echo "Setting up Odoo data directory..."

# Ensure the odoo user exists and get its UID/GID
ODOO_UID=$(id -u odoo 2>/dev/null || echo "104")
ODOO_GID=$(id -g odoo 2>/dev/null || echo "107")

echo "Odoo UID: $ODOO_UID, GID: $ODOO_GID"

# Create data directory structure
mkdir -p /var/lib/odoo/filestore
mkdir -p /var/lib/odoo/sessions
mkdir -p /var/lib/odoo/addons

# Set proper ownership
chown -R $ODOO_UID:$ODOO_GID /var/lib/odoo
chmod -R 755 /var/lib/odoo

echo "Data directory setup complete"

# Check if volume is properly mounted
if [ -w "/var/lib/odoo" ]; then
    echo "Data directory is writable"
else
    echo "ERROR: Data directory is not writable!"
    exit 1
fi

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

if [ "${ODOO_RESET}" = "1" ]; then
  echo "RESETTING DATABASE COMPLETELY..."
  echo "This will remove all data and filestore!"
  
  # Clear filestore if it exists
  if [ -d "/var/lib/odoo/filestore/${ODOO_DATABASE_NAME}" ]; then
    echo "Removing existing filestore..."
    rm -rf "/var/lib/odoo/filestore/${ODOO_DATABASE_NAME}"
  fi
  
  # Reset database with init
  ODOO_CMD="$ODOO_CMD --init=all --stop-after-init"
  echo "Running database reset..."
  runuser -u odoo -- $ODOO_CMD
  
  echo "Database reset complete. Starting normal mode..."
  # Start normally after reset
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
    
elif [ "${ODOO_INIT}" = "1" ]; then
  echo "Initializing database with modules..."
  ODOO_CMD="$ODOO_CMD --init=all"
else
  echo "Starting Odoo normally (no initialization)"
fi

echo "Final command: $ODOO_CMD"
echo "Switching to odoo user and starting Odoo..."

# Run as odoo user
exec runuser -u odoo -- $ODOO_CMD