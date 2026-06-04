# cocos_flutter

Proyek Flutter: Aleph-4_cocos — aplikasi mobile cross-platform yang
menggabungkan fitur e‑commerce dan sosial (auth, cart, chat, checkout,
events, products, profile, dsb.). README ini menjelaskan cara menyiapkan,
menjalankan, dan membangun proyek hingga tahap sekarang.

## Ringkasan
- **Platform:** Android, iOS, Web, Windows, macOS, Linux
- **Bahasa & Framework:** Dart, Flutter
- **Entry point:** [lib/main.dart](lib/main.dart)
- **Manajemen dependensi:** [pubspec.yaml](pubspec.yaml)

## Fitur Utama
- Autentikasi pengguna (folder: `lib/features/auth`)
- Keranjang dan proses checkout (`lib/features/cart`, `lib/features/checkout`)
- Chat dan notifikasi (`lib/features/chat`)
- Manajemen produk dan pameran (`lib/features/product`)
- Halaman profil dan pesanan (`lib/features/profile`, `lib/features/orders`)
- Beranda dan event listing (`lib/features/home`, `lib/features/events`)

## Prasyarat
- Install Flutter SDK (disarankan versi stabil terbaru). Panduan: https://docs.flutter.dev/
- Android Studio / Xcode untuk emulator dan toolchain native
- (Opsional) Web browser untuk target web, dan toolchain desktop untuk build desktop

## Persiapan Proyek (Setup)
1. Clone repo dan masuk ke direktori proyek:

```bash
git clone <repo-url>
cd cocos_flutter
```

2. Pasang dependensi:

```bash
flutter pub get
```

3. (Jika perlu) Generate kode yang diperlukan (jika ada generator digunakan):

```bash
# contoh: flutter pub run build_runner build --delete-conflicting-outputs
```

## Menjalankan Aplikasi
- Jalankan di emulator Android:

```bash
flutter run -d emulator-5554
```

- Jalankan di iOS simulator (macOS):

```bash
flutter run -d ios
```

- Jalankan di web:

```bash
flutter run -d chrome
```

- Jalankan di desktop (Windows/macOS/Linux), jika diaktifkan:

```bash
flutter run -d windows
```

## Membangun Release
- APK Android:

```bash
flutter build apk --release
```

- App Bundle Android:

```bash
flutter build appbundle
```

- iOS (macOS + Xcode):

```bash
flutter build ipa
```

- Web:

```bash
flutter build web
```

## Struktur Proyek (ringkas)
- `lib/` — kode sumber utama
	- `main.dart` — entry point aplikasi ([lib/main.dart](lib/main.dart))
	- `core/` — konstanta, tema, utilitas, widget bersama
	- `features/` — modul fitur (auth, cart, chat, product, dsb.)
- `assets/` — gambar dan aset statis (lihat `assets/`)
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` — folder platform native
- `pubspec.yaml` — deklarasi dependensi dan aset ([pubspec.yaml](pubspec.yaml))

## Aset dan Lokalisasi
- Semua aset gambar berada di folder `assets/` (mis. `assets/product_images/`).
- Jika menambahkan aset baru, daftarkan di `pubspec.yaml` di bawah bagian `flutter.assets`.

## Debugging dan Troubleshooting
- Jika ada error dependency, jalankan `flutter clean` lalu `flutter pub get`.
- Pastikan versi Flutter sesuai dengan yang dibutuhkan oleh paket-paket yang digunakan.
- Untuk masalah platform native, lihat log dengan `flutter run --verbose` dan perbaiki berdasarkan pesan error.

## Testing
- Terdapat contoh test dasar di folder `test/`. Jalankan semua test dengan:

```bash
flutter test
```

## Kontribusi
- Buat branch baru untuk fitur atau perbaikan bug: `git checkout -b feat/nama-fitur`.
- Buat PR ke branch utama dengan deskripsi perubahan dan testing yang dilakukan.

## Catatan Tambahan
- Rute aplikasi utama didefinisikan di [lib/routes/app_routes.dart](lib/routes/app_routes.dart).
- Lihat `buildLog.txt` jika membutuhkan referensi build sebelumnya.

## Lisensi
- Jika ada file `LICENSE`, silakan periksa untuk informasi lisensi. Jika belum ada, tambahkan lisensi yang sesuai.

---

Jika Anda ingin saya tambahkan contoh konfigurasi CI, langkah rilis otomatis, atau dokumentasi komponen lebih rinci (mis. struktur `features/product`), beri tahu saya bagian mana yang perlu diperluas.
