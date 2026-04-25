# KecamatanSAE Mini (Landing Page Only)

Repository ini berisi **hanya** Landing Page (Dashboard Utama) dari proyek KecamatanSAE. 
Layanan lain seperti **WAHA** dan **n8n** dideploy secara terpisah di VPS lain.

## Cara Menghubungkan ke WAHA & n8n

Meskipun layanan WAHA dan n8n tidak ada di repository ini, Landing Page tetap memerlukan koneksi ke layanan tersebut. 
Silakan atur variabel berikut di file `.env` Anda:

```env
# URL Publik WAHA (di VPS lain)
WAHA_API_URL=https://waha.vps-anda.com
WAHA_API_KEY=key_waha_anda

# URL Publik n8n Webhook (di VPS lain)
N8N_REPLY_WEBHOOK_URL=https://n8n.vps-anda.com/webhook/whatsapp-besuk

# Token Keamanan API
WHATSAPP_API_TOKEN=secret_token_untuk_komunikasi
DASHBOARD_API_TOKEN=secret_token_untuk_dashboard
```

## Cara Menjalankan

1. Salin `.env.example` menjadi `.env`.
2. Sesuaikan konfigurasi database dan URL eksternal (WAHA/n8n).
3. Jalankan Docker:
   ```bash
   docker-compose up -d --build
   ```
4. Jalankan migrasi database:
   ```bash
   docker-compose exec app php artisan migrate --seed
   ```

---
Dibuat dengan ❤️ untuk Kecamatan Besuk.
