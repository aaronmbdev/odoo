FROM odoo:17.0

ARG LOCALE=en_US.UTF-8

ENV LANGUAGE=${LOCALE}
ENV LC_ALL=${LOCALE}
ENV LANG=${LOCALE}

# Switch to root to install dependencies and set up directories
USER root

# Install additional packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    netcat-openbsd \
    && locale-gen ${LOCALE} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create data directory with proper permissions
RUN mkdir -p /var/lib/odoo/filestore \
    && mkdir -p /var/lib/odoo/sessions \
    && mkdir -p /var/lib/odoo/addons \
    && chown -R odoo:odoo /var/lib/odoo \
    && chmod -R 755 /var/lib/odoo

WORKDIR /app

# Copy entrypoint script
COPY --chmod=755 entrypoint.sh ./

# Expose the port
EXPOSE 8069

ENTRYPOINT ["/bin/sh"]
CMD ["entrypoint.sh"]