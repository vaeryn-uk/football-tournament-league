from django.db import models

class League(models.Model):
    name = models.TextField()

class Match(models.Model):
    team1 = models.CharField(max_length=50)
    team2 = models.CharField(max_length=50)
    team1Score = models.IntegerField(null=True)
    team2Score = models.IntegerField(null=True)
    league = models.ForeignKey(League, on_delete=models.CASCADE)