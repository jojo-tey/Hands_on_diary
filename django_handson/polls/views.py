from django.http import HttpResponse, Http404, HttpResponseRedirect
from django.shortcuts import render, get_object_or_404
from django.urls import reverse
from django.views import generic
from .models import Question, Choice
from django.utils import timezone

# Create your views here.

# 클래스뷰(generic), 함수뷰(def)
# 뷰를 만들고 -> 호출하려면 url을 연결해줘야함


class IndexView(generic.ListView):
    template_name = 'index.html'
    context_object_name = 'latest_question_list'

    def get_queryset(self):
        """Return the last five published questions."""
        return Question.objects.filter(pub_date__lte=timezone.now()).order_by('-pub_date')[:5]


# ID를 통해 각 모델을 가져올 수 있음

# id가 존재하지 않을경우 404 페이지 불러오는방법 두가지(Http404 & get_object_or_404)
class DetailView(generic.DetailView):
    model = Question
    template_name = 'detail.html'

    def get_queryset(self):
        """Excludes any questions that fren`t published yet"""
        return Question.objects.filter(pub_date__lte=timezone.now())

    # try:
    #     question = Question.objects.get(pk=question_id)
    # except Question.DoesNotExist:
    #     raise Http404("Question does not exist")
    # return render(request, 'detail.html', {'question': question})


class ResultsView(generic.DetailView):
    model = Question
    template_name = 'detail.html'

    # question = get_object_or_404(Question, pk=question_id)
    # return render(request, 'results.html', {'question': question})


def vote(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    try:
        selected_choice = question.choice_set.get(pk=request.POST['choice'])
    except (KeyError, Choice.DoesNotExist):
        # Redisplay the question voting form.
        return render(request, 'detail.html', {
            'question': question,
            'error_message': "You didn't select a choice.",
        })
    else:
        selected_choice.votes += 1
        selected_choice.save()
        # Always return an HttpResponseRedirect after successfully dealing
        # with POST data. This prevents data from being posted twice if a
        # user hits the Back button.
        return HttpResponseRedirect(reverse('results', args=(question.id,)))


# Test on shell
