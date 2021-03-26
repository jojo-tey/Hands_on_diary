from django import forms


class BoardForm(forms.Form):
    title = forms.CharField(
        error_messages={'required': "Title"}, label="title", max_length=128)
    contents = forms.CharField(
        error_messages={'required': "Content"}, label="content", widget=forms.Textarea)
