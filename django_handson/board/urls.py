from django.urls import path
from . import views


urlpatterns = [
    path('new/', views.board_write, name='new'),
    # path('list/', views.board_list, name='list'),
    # path('detail/', views.board_detail, name='detail'),
]
