# docker-django

## Dockerfile
According to your django project, you will probably need to add some packages  
By example, jpeg-dev and zlib-dev are dependencies for pillow

mariadb-libs and mariadb-dev are need, because libmysqlclient-dev are not available on alpine linux :(

django, mysqlclient and other stuff, are in requirements.txt, not in dockerfile

## Config
organisation django app must be something like that:
```
html
└──project
	├── manage.py
	├── app
	│   ├── __init__.py
	│   ├── models.py
	│   ├── tests.py
	│   └── views.py
	├── project
	│   ├── settings.py
	│   ├── urls.py
	│   └── wsgi.py
	└── requirements.txt
```
if you want different name for project, change:  
- project (inner) in config_uwsgi/django.ini
- project (outer) in nginx/conf.d/site-available/django01.conf

pip requirements
```
ln -s html/project_files/requirements.txt .
```

## Database
### container mariadb
```
cp mariadb.config.env.sample mariadb.config.env
cp php.config.env.sample php.config.env
```
then, change default value if needed ...


### django
configure `project/project/settings.py`:
```
DATABASES = {
	'default': {
		'ENGINE': 'django.db.backends.mysql',
		'NAME': 'project_db',
		'USER': 'root',
		'PASSWORD': 'root',
		'HOST': 'db',
		'PORT': '3306',
	}
}
```

## Install

### dev environment
#### create project
named according to uwsgi and nginx config
```
$ docker exec -it django_container django-admin startproject project
```
#### create app
```
$ docker exec -it django_container python manage.py startapp app
```

### apply tabe modifications
```
$ docker exec -it django_container python manage.py makemigrations
```

### create tables
```
$ docker exec -it django_container python manage.py migrate
```

### collect static file
```
$ docker exec -it django_container python /app/project_files/manage.py collectstatic --noinput
```

### create superuser (if need)
```
$ docker exec -it django_container python /app/manage.py createsuperuser --username coolName --email email@address.com
```
