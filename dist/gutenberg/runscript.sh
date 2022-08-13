#!/bin/bash -i

sed -i "s|%%POSTGRES_SERVER%%|$POSTGRES_SERVER|g" /app/gutenberg/gutenberg/settings/production_settings.py
sed -i "s|%%POSTGRES_PASSWORD%%|$POSTGRES_PASSWORD|g" /app/gutenberg/gutenberg/settings/production_settings.py
sed -i "s|%%POSTGRES_USER%%|$POSTGRES_USER|g" /app/gutenberg/gutenberg/settings/production_settings.py
sed -i "s|%%POSTGRES_DB%%|$POSTGRES_DB|g" /app/gutenberg/gutenberg/settings/production_settings.py
sed -i "s|%%POSTGRES_PORT%%|$POSTGRES_PORT|g" /app/gutenberg/gutenberg/settings/production_settings.py
sed -i "s|%%REDIS_PORT%%|$REDIS_PORT|g" /app/gutenberg/gutenberg/settings/production_settings.py
sed -i "s|%%REDIS_SERVER%%|$REDIS_SERVER|g" /app/gutenberg/gutenberg/settings/production_settings.py
sed -i "s|%%REDIS_PASSWORD%%|$REDIS_PASSWORD|g" /app/gutenberg/gutenberg/settings/production_settings.py
sed -i "s|%%GUTENBERG_SECRETKEY%%|$GUTENBERG_SECRETKEY|g" /app/gutenberg/gutenberg/settings/production_settings.py
sed -i "s|%%DJANGO_SETTINGS_MODULE%%|$DJANGO_SETTINGS_MODULE|g" /app/gutenberg/gutenberg.ini
sed -i "s|%%SERVER_VHOST%%|$SERVER_VHOST|g" /etc/nginx/sites-enabled/default

chown -R gutenberg:gutenberg /prints


if [ ! -f /setup/initialfinished ]
then
    python3 /app/gutenberg/gutenberg/manage.py createsuperuser
    touch /setup/initialfinished
else
    echo "File found"
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
