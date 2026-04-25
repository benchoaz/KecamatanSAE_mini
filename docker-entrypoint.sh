#!/bin/sh
# set -e  <-- DIBUAT TIDAK KETAT agar tidak mati saat boot error database

# ============================================================
# Laravel Robust Production Entrypoint (Resilient Version)
# ============================================================

echo "🚀 Initializing SILAP Application Environment..."

# 1. Wait for Database
echo "⏳ Waiting for Database (Postgres)..."
until nc -z db 5432; do
  echo "Still waiting for postgres at db:5432..."
  sleep 2
done
echo "✅ Database is reachable."

# 2. Wait for Redis
echo "⏳ Waiting for Redis..."
until nc -z redis 6379; do
  echo "Still waiting for redis at redis:6379..."
  sleep 2
done
echo "✅ Redis is reachable."

# 3. Ensure storage directories exist
echo "📁 Checking storage permissions..."
mkdir -p storage/framework/{cache,sessions,views}
mkdir -p storage/app/public
mkdir -p bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# 4. Database Migrations (PRIORITAS UTAMA)
# Kita jalankan migrasi lebih awal untuk mencegah error "Undefined table"
echo "🗄️ Running database migrations..."
php artisan migrate --force --no-interaction || echo "⚠️ Migration failed or already run, continuing..."

# 5. Handle APP_KEY if missing
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "" ]; then
    echo "🔑 APP_KEY is missing, generating one..."
    php artisan key:generate --force --no-interaction || echo "⚠️ Key generate failed (probably table missing), will retry later."
fi

# 6. Laravel Optimization
echo "⚙️ Optimizing configuration..."
php artisan optimize:clear || echo "⚠️ Optimize clear failed."
php artisan config:cache || echo "⚠️ Config cache failed."

# 7. Start the application
echo "🏁 SILAP Application is READY!"
exec "$@"
