from django.http import HttpResponse, Http404
from django.shortcuts import render
from .models import Question
# Create your views here.


# 뷰를 만들고 -> 호출하려면 url을 연결해줘야함
def index(request):
    latest_question_list = Question.objects.order_by('-pub_date')[:5]
    context = {'latest_question_list': latest_question_list}
    return render(request, 'index.html', context)


# ID를 통해 각 모델을 가져올 수 있음

def detail(request, question_id):
    try:
        question = Question.objects.get(pk=question_id)
    except Question.DoesNotExist:
        raise Http404("Question does not exist")
    return render(request, 'detail.html', {'question': question})


def results(request, question_id):
    response = "You`re looking at the results of question %s"
    return HttpResponse(response % question_id)


def vote(request, question_id):
    return HttpResponse("You`re voting on question %s." % question_id)
