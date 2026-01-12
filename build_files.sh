# build_files.sh
echo "--- Starting Build Process ---"

# 1. Ensure the environment is ready using the python3 module path
# This prevents the "No module named pip" error seen in your logs
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt

echo "--- Running Migrations ---"
# 2. Use python3 to ensure it finds the installed Django 6.0
# This creates tables in your newly connected Neon/Postgres database
python3 manage.py makemigrations --noinput
python3 manage.py migrate --noinput

echo "--- Creating Superuser ---"
# 3. This script uses your Vercel Environment Variables to create your admin
python3 manage.py shell <<EOF
from django.contrib.auth import get_user_model
import os
User = get_user_model()
username = os.environ.get('DJANGO_SUPERUSER_USERNAME', 'admin')
email = os.environ.get('DJANGO_SUPERUSER_EMAIL', 'admin@example.com')
password = os.environ.get('DJANGO_SUPERUSER_PASSWORD', 'admin123')

if not User.objects.filter(username=username).exists():
    print(f"Creating superuser: {username}")
    User.objects.create_superuser(username, email, password)
else:
    print(f"Superuser {username} already exists")
EOF

echo "--- Collecting Static Files ---"
# 4. Create the directory manually to avoid the "No Output Directory" error
mkdir -p staticfiles_build/static
python3 manage.py collectstatic --noinput --clear

echo "--- Build Finished Successfully ---"