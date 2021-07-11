from django.contrib import admin

# Register your models here.
from . import models

admin.site.register(models.League)
admin.site.register(models.Match)