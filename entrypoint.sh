#!/bin/sh
set -e

echo "⏳ Waiting for DB..."
while ! nc -z "$HOST" "$PORT"; do
  sleep 1
done

echo "🔧 Running migrations..."
python manage.py migrate

echo "🚀 Starting server..."
exec python manage.py runserver 0.0.0.0:8080
