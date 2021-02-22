from django.contrib import admin


# To modify in admin page, need to define here

from .models import Question, Choice


admin.site.register(Question)
admin.site.register(Choice)
