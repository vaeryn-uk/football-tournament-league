from django.test import TestCase, Client

class IndexTestCase(TestCase):
    def test_has_index(self):
        self.assertContains(Client().get('/'), 'Python Practice')