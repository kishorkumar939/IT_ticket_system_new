# build_files.sh
echo "--- Starting Build ---"
python3 -m pip install --upgrade pip
python3 -m pip install PyJWT cryptography  # Force-install these two first
python3 -m pip install -r requirements.txt

mkdir -p staticfiles_build/static
python3 manage.py collectstatic --noinput --clear
echo "--- Build Finished ---"