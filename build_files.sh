# build_files.sh
echo "--- Starting Build Process ---"

# 1. Ensure pip is available and install dependencies first
# This prevents 'ModuleNotFoundError' during later Django commands
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt

echo "--- Running Migrations & Static Files ---"
# 2. Use python3 to ensure the environment's Django 6.0 is found
# Create the directory manually to avoid 'No Output Directory' error
mkdir -p staticfiles_build/static
python3 manage.py collectstatic --noinput --clear

# 3. Create Superuser (Postgres only)
python3 manage.py shell <<EOF
from django.contrib.auth import get_user_model
import os
User = get_user_model()
username = os.environ.get('DJANGO_SUPERUSER_USERNAME', 'admin')
email = os.environ.get('DJANGO_SUPERUSER_EMAIL', 'admin@example.com')
password = os.environ.get('DJANGO_SUPERUSER_PASSWORD', 'admin123')
if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username, email, password)
EOF

echo "--- Build Finished Successfully ---"