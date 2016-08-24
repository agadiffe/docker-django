# docker-django

## Dockerfile
According to your django project, you will probably need to add some packages  
By example, jpeg-dev and zlib-dev are dependencies for pillow

mariadb-libs and mariadb-dev are need, because on alpine, libmysqlclient-dev are not available on alpine linux :(

django, mysqlclient and other stuff, are in requirements.txt, not in dockerfile

## Config

organisation django app must be something like that:
```
html
└──project_files
	├── manage.py
	├── my_app
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
if you want different organization, change:  
- config_uwsgi/django.ini
- nginx/conf.d/site-available/django01.confo

pip requirements
```
ln -s html/project_files/requirements.txt .
```

## Database

don't forgot to configure `project_files/project/settings.py`:
```
DATABASES = {
	'default': {
		'ENGINE': 'django.db.backends.mysql',
		'NAME': 'project_db',
		'USER': 'root',
		'PASSWORD': 'root',
		'HOST': 'djangodb',
		'PORT': '3306',
	}
}
```

### initializing

first time running  
create a database called “project_db” (or whatever you configured)

then, if you listen the django docs: RTFM :)

### apply tabe modifications
```
$ docker exec -it django_container python /app/manage.py imakemigrations
```

### create tables
```
$ docker exec -it django_container python /app/manage.py migrate
```

### collect static file
```
python /app/project_files/manage.py collectstatic --noinput
```

### create superuser
```
$ docker exec -it django_container python /app/manage.py createsuperuser --username coolName --email email@address.com
```
