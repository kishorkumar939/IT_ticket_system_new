# build_files.sh

echo "Building the project..."

# Ensure we use the correct python version and install pip if missing
python3.9 -m ensurepip
python3.9 -m pip install --upgrade pip
python3.9 -m pip install -r requirements.txt

echo "Running Migrations..."
python3.9 manage.py makemigrations --noinput
python3.9 manage.py migrate --noinput

echo "Collect Static..."
# Create the directory manually first to avoid the 'No Output Directory' error
mkdir -p staticfiles_build/static
python3.9 manage.py collectstatic --noinput --clear

echo "Build Finished!"