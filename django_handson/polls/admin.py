from django.contrib import admin


# To modify in admin page, need to define here

from .models import Question, Choice


# admin page customizing

class QuestionAdmin(admin.ModelAdmin):
    fieldsets = [
        (None,               {'fields': ['question_text']}),
        ('Date information', {'fields': ['pub_date']}),
    ]
    list_display = ('question_text', 'pub_date', 'was_published_recently')


class ChoiceInline(admin.TabularInline):
    model = Choice
    extra = 3
