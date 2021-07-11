from django.shortcuts import render
from django.core.exceptions import ObjectDoesNotExist
from django.http import HttpResponse, HttpResponseNotFound
from .models import League

def leagues(request):
    return render(request, 'leagues/leagues.html', {'leagues': League.objects.all()})

def league(request, id):
    try:
        league = League.objects.get(pk=id)
    except ObjectDoesNotExist:
        return HttpResponseNotFound('Not found')

    return render(request, 'leagues/league.html', {'league': league, 'matches': league.match_set.all()})