#!/bin/sh

set -e

echo "Starting Odoo..."

# Wait for database to be available
echo "Waiting for database connection..."
while ! nc -z "${ODOO_DATABASE_HOST}" "${ODOO_DATABASE_PORT}" 2>/dev/null; do
    echo "Database not ready, waiting..."
    sleep 2
done
echo "Database is available!"

# Set up data directory with proper permissions
echo "Setting up Odoo data directory..."
mkdir -p /var/lib/odoo/filestore
mkdir -p /var/lib/odoo/sessions
mkdir -p /var/lib/odoo/addons

# Ensure proper ownership
chown -R odoo:odoo /var/lib/odoo
chmod -R 755 /var/lib/odoo

echo "Starting Odoo server on port ${PORT:-8069}..."

# Start Odoo as the odoo user
exec runuser -u odoo -- odoo \
    --http-port=${PORT:-8069} \
    --without-demo=True \
    --proxy-mode \
    --data-dir=/var/lib/odoo \
    --db_host="${ODOO_DATABASE_HOST}" \
    --db_port=${ODOO_DATABASE_PORT} \
    --db_user="${ODOO_DATABASE_USER}" \
    --db_password="${ODOO_DATABASE_PASSWORD}" \
    --database="${ODOO_DATABASE_NAME}" \
    --db_template=template0 \
    --smtp="${ODOO_SMTP_HOST}" \
    --smtp-port=${ODOO_SMTP_PORT_NUMBER} \
    --smtp-user="${ODOO_SMTP_USER}" \
    --smtp-password="${ODOO_SMTP_PASSWORD}" \
    --email-from="${ODOO_EMAIL_FROM}"