#!/bin/sh

set -e

# collect static files 
python manage.py collectstatic --noinput  

# wsgi파일 path확인후 설정(장고에서 기본적으로 만들어짐)
uwsgi --socket :8000 --master --enable-threads --module app.wsgi
