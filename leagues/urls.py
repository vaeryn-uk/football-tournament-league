from django.urls import path
from . import views

app_name = 'leagues'
urlpatterns = [
    path('', views.leagues, name='leagues'),
    path('<int:id>', views.league, name='league'),
]