# docker-django

## Config

django files must to be in project_files  
(means manage.py is in project_files dir)  
if no app is present, the build will fail ..  

the config file must be in project dir.
(or modify the dockerfile)

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

## Initializing

first time running  
create a database called “project_db” (or whatever you configured)

then, if you listen the django docs:
```
# Create tables
$ docker exec -it django_container python /app/manage.py migrate

# Create superuser
$ docker exec -it django_container python /app/manage.py createsuperuser --username coolName --email email@address.com
```
