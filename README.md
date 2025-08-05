# Odoo Railway Deployment

A simple, production-ready Odoo deployment for Railway with persistent storage.

## Features

- ✅ **Persistent file storage** - Volume mounted at `/var/lib/odoo`
- ✅ **PostgreSQL integration** - Easy database connection
- ✅ **SMTP configuration** - Email functionality
- ✅ **Production optimized** - Proper user permissions and security

## Quick Start

### 1. Deploy to Railway

1. Fork or clone this repository
2. Connect it to Railway
3. Add a PostgreSQL service to your Railway project

### 2. Configure Environment Variables

Set these required variables in Railway:
```
ODOO_DATABASE_HOST=<postgres-host>
ODOO_DATABASE_PORT=5432
ODOO_DATABASE_USER=<postgres-user>
ODOO_DATABASE_PASSWORD=<postgres-password>
ODOO_DATABASE_NAME=odoo_production
```

**Security Note:** For production, it's recommended to create a dedicated database user instead of using 'postgres'. You can do this by connecting to your PostgreSQL service and running:
```sql
CREATE USER odoo_user WITH CREATEDB PASSWORD 'your_secure_password';
```
Then use `odoo_user` as your `ODOO_DATABASE_USER`.

### 3. Add Volume

⚠️ **Important**: You must manually create a volume in Railway dashboard:

1. Go to your service in Railway dashboard
2. Click on the "Variables" tab
3. Scroll down to "Volumes" section
4. Click "Add Volume"
5. Set:
   - **Mount path:** `/var/lib/odoo`
   - **Size:** 5GB minimum (recommended: 10GB+)

### 4. Deploy

Deploy your service. Odoo will automatically set up the database on first run.

## Environment Variables

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `ODOO_DATABASE_HOST` | ✅ | PostgreSQL hostname | `postgres.railway.internal` |
| `ODOO_DATABASE_PORT` | ✅ | PostgreSQL port | `5432` |
| `ODOO_DATABASE_USER` | ✅ | Database username | `postgres` |
| `ODOO_DATABASE_PASSWORD` | ✅ | Database password | `your-secret-password` |
| `ODOO_DATABASE_NAME` | ✅ | Database name | `odoo_production` |
| `PORT` | 🔧 | HTTP port | `8069` (auto-set by Railway) |
| `ODOO_SMTP_HOST` | ❌ | SMTP server | `smtp.gmail.com` |
| `ODOO_SMTP_PORT_NUMBER` | ❌ | SMTP port | `587` |
| `ODOO_SMTP_USER` | ❌ | SMTP username | `your-email@gmail.com` |
| `ODOO_SMTP_PASSWORD` | ❌ | SMTP password | `your-app-password` |
| `ODOO_EMAIL_FROM` | ❌ | Default sender | `noreply@yourcompany.com` |

## File Structure

```
.
├── Dockerfile              # Container configuration
├── entrypoint.sh           # Startup script
├── railway.json           # Railway deployment config
├── railway-deployment.md  # Detailed deployment guide
└── README.md              # This file
```

## Persistence

The deployment uses a Railway volume mounted at `/var/lib/odoo` to persist:

- 📁 **File uploads and attachments**
- 📁 **User sessions**
- 📁 **Custom modules**
- 📁 **Cache files**
- 📁 **Filestore data**

## Troubleshooting

## Troubleshooting

### Database connection errors:
- Check PostgreSQL service status in Railway
- Verify environment variables are set correctly
- Ensure database name exists

### File permission errors:
- Check that volume is properly mounted to `/var/lib/odoo`
- Verify volume has sufficient space

### Module loading issues:
- Check Odoo logs in Railway dashboard
- Ensure database is properly connected

### First-time setup:
Odoo will automatically create the database and install base modules on first run. This may take a few minutes.

## Security

- 🔒 Runs as non-root user (`odoo`)
- 🔒 Environment variables encrypted by Railway
- 🔒 No hardcoded credentials
- 🔒 Production-ready configuration

## Support

- 📖 [Odoo Documentation](https://www.odoo.com/documentation)
- 🚂 [Railway Documentation](https://docs.railway.app)
- 🐛 [Report Issues](https://github.com/aaronmbdev/odoo/issues)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
