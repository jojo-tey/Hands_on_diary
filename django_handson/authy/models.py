from django.db import models

# Create your models here.


class Users(models.Model):
    username = models.CharField(max_length=32, verbose_name="username")
    password = models.CharField(max_length=64, verbose_name="password")
    useremail = models.CharField(max_length=128, verbose_name="email")
    registered_date = models.DateTimeField(
        auto_now_add=True, verbose_name="registered_date")

    def __str__(self):
        return self.username

    class Meta:
        verbose_name = "user"
        verbose_name_plural = "users"
