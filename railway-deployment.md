# Railway Deployment Guide for Odoo

## Environment Variables Required

### Database Configuration (PostgreSQL)
- `ODOO_DATABASE_HOST` - PostgreSQL host (from Railway PostgreSQL service)
- `ODOO_DATABASE_PORT` - PostgreSQL port (usually 5432)
- `ODOO_DATABASE_USER` - PostgreSQL username
- `ODOO_DATABASE_PASSWORD` - PostgreSQL password
- `ODOO_DATABASE_NAME` - Database name for Odoo (e.g., "odoo_production")

### Server Configuration
- `PORT` - Port for Odoo server (Railway will provide this automatically)

### SMTP Configuration (Optional)
- `ODOO_SMTP_HOST` - SMTP server hostname
- `ODOO_SMTP_PORT_NUMBER` - SMTP port (587 for TLS, 465 for SSL)
- `ODOO_SMTP_USER` - SMTP username
- `ODOO_SMTP_PASSWORD` - SMTP password
- `ODOO_EMAIL_FROM` - Default email sender address

## Volume Configuration

**Mount Path:** `/var/lib/odoo`
**Recommended Size:** 5GB minimum (more for production with file uploads)

This volume will persist:
- File attachments and uploads
- Session data
- Custom addons
- Cache files

## Deployment Steps

### 1. Set up PostgreSQL
Add a PostgreSQL service to your Railway project.

### 2. Configure Environment Variables
Set all required environment variables in your Railway service settings.

### 3. Add Volume
Create a volume and mount it to `/var/lib/odoo`

### 4. Deploy
Deploy your service. Odoo will handle database setup automatically on first run.

## Troubleshooting

### Database connection errors
- Check PostgreSQL service status and credentials
- Verify environment variables are correct

### File permission issues
- Ensure volume is mounted correctly
- Check Railway logs for permission errors

### Module loading errors
- Monitor Railway logs during startup
- Ensure database connection is stable

## Security Notes
- Never expose database credentials in public repositories
- Use Railway's environment variable encryption
- Regularly backup your PostgreSQL database
- Monitor file upload sizes and volume usage
