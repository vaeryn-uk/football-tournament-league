from django.db import models

# Create your models here.
class Match(models.Model):
    team1 = models.CharField(max_length=50)
    team2 = models.CharField(max_length=50)
    team1Score = models.IntegerField(null=True)
    team2Score = models.IntegerField(null=True)