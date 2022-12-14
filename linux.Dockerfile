# escape=`

FROM debian:11 AS builder
WORKDIR /dl

RUN apt-get update && apt-get install -y git curl gnupg2

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get install --no-install-recommends -y yarnpkg

RUN git clone https://github.com/KSIUJ/gutenberg.git
COPY /dist/gutenberg/settings /dl/gutenberg/gutenberg/settings
RUN rm -rf /dl/gutenberg/sandbox.sh

WORKDIR /dl/gutenberg
RUN yarnpkg install
RUN yarnpkg build


FROM debian:11
HEALTHCHECK NONE
ARG BUILDNODE=unspecified
ARG SOURCE_COMMIT=unspecified
ENV DJANGO_SETTINGS_MODULE=gutenberg.settings.production_settings

LABEL com.lacledeslan.build-node=$BUILDNODE `
      org.label-schema.schema-version="1.0" `
      org.label-schema.url="https://volzit.de" `
      org.label-schema.vcs-ref=$SOURCE_COMMIT `
      org.label-schema.vendor="volzit" `
      org.label-schema.description="Gutenberg office printer gateway docker image" `
      org.label-schema.vcs-url="https://github.com/Apfelwurm/docker-gutenberg"


RUN apt-get update && apt-get install -y `
    net-tools nano supervisor cups printer-driver-all foomatic-db-engine hp-ppd openprinting-ppds hplip imagemagick libmagic-dev  unoconv ghostscript bubblewrap pdftk python3 python3-pip python3-venv uwsgi-plugin-python3 libpq-dev nginx &&`
    apt-get clean &&`
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*;

RUN useradd --user-group --system --create-home --no-log-init gutenberg

COPY --chown=gutenberg:gutenberg --from=builder /dl/gutenberg /app/gutenberg


COPY --chown=gutenberg:gutenberg /dist/linux/ll-tests /app/ll-tests
COPY --chown=gutenberg:gutenberg /dist/gutenberg/runscript.sh /app/gutenberg/runscript.sh
COPY --chown=gutenberg:gutenberg /dist/gutenberg/gutenberg.ini /app/gutenberg/gutenberg.ini
COPY --chown=gutenberg:gutenberg /dist/gutenberg/sandbox.sh /app/gutenberg/sandbox.sh
RUN chmod +x /app/gutenberg/sandbox.sh
COPY /dist/linux/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY /dist/linux/cups/* /defaultconfig/cups/
COPY /dist/linux/nginx/nginx.conf /etc/nginx/sites-enabled/default
RUN chmod +x /app/ll-tests/*.sh; chmod +x /app/gutenberg/runscript.sh;

WORKDIR /prints
WORKDIR /var/log/gutenberg
# WORKDIR /var/log/nginx
# WORKDIR /var/lib/nginx
# WORKDIR /var/lib/nginx/body
# WORKDIR /var/lib/nginx/fastcgi
# WORKDIR /var/lib/nginx/proxy
# WORKDIR /var/lib/nginx/uwsgi
# WORKDIR /var/lib/nginx/scgi

RUN chown -R gutenberg:gutenberg /prints
RUN chown -R gutenberg:gutenberg /var/log/gutenberg
# RUN chown -R gutenberg:gutenberg /var/log/nginx

USER gutenberg
RUN python3 -m venv /app/gutenberg/gutenberg/venv
USER root
RUN chmod +x /app/gutenberg/gutenberg/venv/bin/*
WORKDIR /app/gutenberg/
USER gutenberg
RUN /app/gutenberg/gutenberg/venv/bin/pip3 install -r requirements.txt
RUN /app/gutenberg/gutenberg/venv/bin/pip3 install psycopg2

USER root
RUN ln -s /app/gutenberg/dist /app/gutenberg/static
RUN ln -s /app/gutenberg/gutenberg/venv/lib/python3.9/site-packages/django/contrib/admin/static/admin /app/gutenberg/dist/admin

WORKDIR /app
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /app/wait
RUN chmod +x /app/wait
WORKDIR /app/gutenberg/
# ONBUILD USER root

CMD [ "/app/gutenberg/runscript.sh" ]
