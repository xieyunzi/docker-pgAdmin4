FROM python:2.7-alpine

ENV PGADMIN_VERSION=1.3

RUN apk add --no-cache alpine-sdk postgresql postgresql-dev \
 && echo "https://ftp.postgresql.org/pub/pgadmin3/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py2.py3-none-any.whl" > link.txt \
 && pip install --upgrade pip \
 && pip install --no-cache-dir -r link.txt \
 && addgroup -g 50 -S pgadmin \
 && adduser -D -S -h /pgadmin -s /sbin/nologin -u 1000 -G pgadmin pgadmin \
 && mkdir -p /data/config /data/storage /data/sessions; chown -R 1000:50 /data \
 && apk del alpine-sdk \
 && rm -rf /root/.cache

ENV SERVER_MODE   false
ENV SERVER_PORT   5050
ENV MAIL_SERVER   mail.example.tld
ENV MAIL_PORT     465
ENV MAIL_USE_SSL  true
ENV MAIL_USERNAME username
ENV MAIL_PASSWORD password

COPY LICENSE config_local.py /usr/local/lib/python2.7/site-packages/pgadmin4/

USER pgadmin:pgadmin
VOLUME /data/

CMD [ "python", "./usr/local/lib/python2.7/site-packages/pgadmin4/pgAdmin4.py" ]
EXPOSE $SERVER_PORT