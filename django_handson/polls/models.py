from django.db import models
from django.utils import timezone
import datetime

# 저장하는 데이터의 필드와 동작을 정의.
# 모델의 원칙 : 반복하지말것(DRY), 명시적, 일관성, 모든 관련 도메인 로직 포함


class Question(models.Model):
    # CharField는 필수적으로 max_length를 설정해줘야함
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')

    def __str__(self):
        return self.question_text

    def was_published_recently(self):
        return self.pub_date >= timezone.now() - datetime.timedelta(days=1)


class Choice(models.Model):
    # ForeignKey의 관계설정 : 각각의 Choice가 하나의 Qeustion에 관계된다는것을 알려줌
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)

    def __str__(self):
        return self.choice_text
