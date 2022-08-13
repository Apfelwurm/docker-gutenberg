# escape=`

FROM debian:11 AS builder
WORKDIR /dl

RUN apt-get update && apt-get install -y git curl gnupg2

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get install --no-install-recommends -y yarnpkg

RUN git clone https://github.com/KSIUJ/gutenberg.git
COPY /dist/gutenberg/settings /dl/gutenberg/gutenberg/settings

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
    supervisor cups printer-driver-all foomatic-db-engine hp-ppd openprinting-ppds imagemagick libmagic-dev  unoconv ghostscript bubblewrap pdftk python3 python3-pip python3-venv uwsgi-plugin-python3 libpq-dev nginx &&`
    apt-get clean &&`
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*;

RUN useradd --user-group --system --create-home --no-log-init gutenberg

COPY --chown=gutenberg:gutenberg --from=builder /dl/gutenberg /app/gutenberg

COPY --chown=gutenberg:gutenberg /dist/linux/ll-tests /app/ll-tests
COPY --chown=gutenberg:gutenberg /dist/gutenberg/runscript.sh /app/gutenberg/runscript.sh
COPY --chown=gutenberg:gutenberg /dist/gutenberg/gutenberg.ini /app/gutenberg/gutenberg.ini
COPY /dist/linux/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod +x /app/ll-tests/*.sh; chmod +x /app/gutenberg/runscript.sh;

WORKDIR /prints
WORKDIR /var/log/gutenberg

RUN chown -R gutenberg:gutenberg /prints
RUN chown -R gutenberg:gutenberg /var/log/gutenberg

USER gutenberg
RUN python3 -m venv /app/gutenberg/gutenberg/venv
USER root
RUN chmod +x /app/gutenberg/gutenberg/venv/bin/*
WORKDIR /app/gutenberg/
USER gutenberg
RUN /app/gutenberg/gutenberg/venv/bin/pip3 install -r requirements.txt
RUN /app/gutenberg/gutenberg/venv/bin/pip3 install psycopg2

# ONBUILD USER root

EXPOSE 11111
CMD [ "/app/gutenberg/runscript.sh" ]
