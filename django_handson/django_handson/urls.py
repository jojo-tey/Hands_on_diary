"""django_handson URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include

from authy.views import index


urlpatterns = [
    path('admin/', admin.site.urls),
    # view 호출을 위해 view.url에 연결
    # view -> view.url -> conf.url

    path('user/', include('authy.urls')),
    path('board/', include('board.urls')),
    path('', index, name='index'),
]
