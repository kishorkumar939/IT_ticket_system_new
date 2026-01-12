# build_files.sh
echo "--- Starting Build ---"

# 1. Force install pip and essential requirements
python3 -m pip install --upgrade pip
python3 -m pip install requests  # Explicitly force-install to fix your current error
python3 -m pip install -r requirements.txt

echo "--- Running Migrations ---"
python3 manage.py makemigrations --noinput
python3 manage.py migrate --noinput

echo "--- Creating Superuser ---"
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

echo "--- Collecting Static Files ---"
mkdir -p staticfiles_build/static
python3 manage.py collectstatic --noinput --clear

echo "--- Build Finished ---"