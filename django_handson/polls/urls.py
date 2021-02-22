from django.urls import path
from . import views

# view의 호출을 위한 url 설정
urlpatterns = [
    # path의 인수 : route, view, kwargs, name(이름을 지으면 템플릿을 포함해 어디서나 명확하게 참조 가능)
    path('', views.IndexView.as_view(), name='index'),
    path('<int:pk>/', views.DetailView.as_view(), name='detail'),
    path('<int:pk>/results/',
         views.ResultsView.as_view(), name='results'),
    path('<int:question_id>/vote/', views.vote, name='vote'),
]
