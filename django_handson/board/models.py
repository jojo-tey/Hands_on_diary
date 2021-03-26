from django.db import models

# Create your models here.


class Board(models.Model):
    title = models.CharField(max_length=64, verbose_name="title")
    content = models.TextField(verbose_name="content")
    registered_date = models.DateTimeField(
        auto_now_add=True, verbose_name="registered_date")
    writer = models.ForeignKey(
        'authy.Users', verbose_name="writer", on_delete=models.CASCADE)

    def __str__(self):
        return self.title

    class Meta:
        db_table = "community_board"
        verbose_name = "content"
        verbose_name_plural = "contents"
