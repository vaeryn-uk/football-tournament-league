from django.http import HttpResponse, HttpRequest
from django.template import loader, Template

def index(request: HttpRequest) -> HttpResponse:
    template : Template = loader.get_template('index/index.html')
    return HttpResponse(template.render({'name': request.GET.get('name', 'Unknown')}))