from django.contrib import admin


# To modify in admin page, need to define here

from .models import Question


admin.site.register(Question)
