from django.contrib.auth import get_user_model
from django.core.management.base import BaseCommand, CommandError
from django.contrib.auth.models import User
import os

class Command(BaseCommand):
    help = 'Creates a Django admin user from environment variables'

    def handle(self, *args, **options):
        user = get_user_model()

        # Delete any existing user matches (by email).
        User.objects.filter(email=os.environ['DJANGO_ADMIN_EMAIL']).delete()

        user.objects.create_superuser(
            os.environ['DJANGO_ADMIN_USER'],
            os.environ['DJANGO_ADMIN_EMAIL'],
            os.environ['DJANGO_ADMIN_PASS']
        )