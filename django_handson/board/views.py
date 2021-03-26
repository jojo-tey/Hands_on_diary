from django.shortcuts import render, redirect
from board.forms import BoardForm
from authy.models import Users
from board.models import Board

# Create your views here.


def board_write(request):
    if not request.session.get('user'):
        return redirect('login')

    if request.method == "GET":
        form = BoardForm()

    elif request.method == "POST":
        form = BoardForm(request.POST)
        if form.is_valid():
            user_id = request.session.get('user')
            user = Users.objects.get(pk=user_id)
            new_board = Board(
                title=form.cleaned_data['title'],
                contents=form.cleaned_data['contents'],
                writer=user
            )
            new_board.save()
            return redirect('/board/list')

    return render(request, 'board/board_write.html', {'form': form})
