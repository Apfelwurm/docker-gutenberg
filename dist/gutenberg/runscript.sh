#!/bin/bash -i


if ! [ -z "${CUPS_PASSWORD}" ]; then
  echo "lpadmin:${CUPS_PASSWORD}" | chpasswd
fi

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

/app/wait

if [ ! -f /setup/initialfinished ]
then
    export DJANGO_SUPERUSER_USERNAME=admin
    export DJANGO_SUPERUSER_PASSWORD=admin
    su gutenberg -c '/app/gutenberg/gutenberg/venv/bin/python3 manage.py migrate'
    su gutenberg -c '/app/gutenberg/gutenberg/venv/bin/python3 manage.py createsuperuser --email admin@admin.com --noinput'
    touch /setup/initialfinished
else
    echo "File found"
fi


if [ ! -f /etc/cups/cupsd.conf ]
then
    cp -rf /defaultconfig/cups/* /etc/cups/
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
