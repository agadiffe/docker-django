#FROM python:2.7-alpine
FROM python:3.5-alpine

COPY requirements.txt /app/
RUN	apk add --no-cache --virtual .build-deps \
		gcc \
		python-dev \
		mysql-client \
		postgresql-client libpq \
		sqlite \
	&& pip install -r /app/requirements.txt \
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
	&& ln -sf /dev/stdout /var/log/uwsgi/emperor.log \
	&& python /app/project_files/manage.py collecstatic --noinput

EXPOSE 29000

CMD /usr/local/bin/uwsgi --emperor /app/config.uwsgi.ini --gid nginx --logto /var/log/uwsgi/emperor.log
