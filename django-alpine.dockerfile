#FROM python:2.7-alpine
FROM python:3.5-alpine

WORKDIR /app

COPY requirements.txt /
RUN	apk add --no-cache --virtual .build-deps \
		gcc \
		linux-headers \
		musl-dev \
		python3-dev \
		mariadb-libs \
		mariadb-dev \
		postgresql-dev \
		libpq \
		sqlite \
		# pillow
		zlib-dev \
		jpeg-dev \
	&& pip install -r /requirements.txt \
	&& find /usr/local \
		\( -type d -a -name test -o -name tests \) \
		-o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		-exec rm -rf '{}' + \
	&& runDeps="$( \
		scanelf --needed --nobanner --recursive /usr/local \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
	&& apk add --virtual .rundeps $runDeps \
	&& apk del .build-deps \
	&& mkdir /var/log/uwsgi \
	&& ln -sf /dev/stdout /var/log/uwsgi/config.uwsgi.log \
	&& ln -sf /dev/stdout /var/log/uwsgi/emperor.log

COPY config_uwsgi/ /config_uwsgi

EXPOSE 29000

CMD /usr/local/bin/uwsgi --emperor /config_uwsgi --logto /var/log/uwsgi/emperor.log
