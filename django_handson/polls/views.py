from django.http import HttpResponse

# Create your views here.


# 뷰를 만들고 -> 호출하려면 url을 연결해줘야함
def index(request):
    return HttpResponse('Hello, you are at the polls index.')
