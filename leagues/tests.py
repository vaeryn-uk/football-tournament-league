from django.test import TestCase, Client
from .models import League, Match

class LeaguesTestCase(TestCase):
    def test_show_league(self):
        league = League.objects.create(name="My Test League")
        Match.objects.create(team1Score=2, team1="Foo", team2Score=0, team2="Bar", league=league)
        self.assertContains(Client().get(f"/leagues/{league.id}"), "League: My Test League")
