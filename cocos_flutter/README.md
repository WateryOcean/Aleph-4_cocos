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

## 🤖 Quick Agent Brief (untuk AI agents)
**Untuk mempelajari codebase ini, agent harus memahami:**

1. **Arsitektur:** Feature-based modular structure (setiap fitur di `lib/features/{feature}/` dengan subfolder: `data/`, `models/`, `views/`, `widgets/`)
2. **Core utilities:** Shared resources ada di `lib/core/` (constants, theme, utils, reusable widgets)
3. **Key files:**
   - Entry point: `lib/main.dart` (app setup dan routing)
   - Routes: `lib/routes/app_routes.dart` (navigasi aplikasi)
   - Theme: `lib/core/theme/app_theme.dart` (styling global)
4. **Features utama:** auth (login), product (katalog), cart (keranjang), checkout, events, chat, profile, orders
5. **Assets:** Semua aset gambar di `lib/assets/` dengan subfolder berdasarkan tipe (product_images/, event_images/, dll)
6. **Testing:** Lihat `test/widget_test.dart` untuk contoh dan jalankan `flutter test`

**Untuk PR baru atau perubahan besar:**
- Ikuti struktur feature-based yang ada
- Update routes di `app_routes.dart` jika menambah halaman baru
- Daftarkan aset baru di `pubspec.yaml` bagian `flutter.assets`
- Ikuti naming convention: snake_case untuk files, PascalCase untuk classes

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

## Struktur Proyek (Lengkap)

### /lib — Kode Sumber Utama

```
lib/
├── main.dart                          # Entry point aplikasi
├── routes/
│   └── app_routes.dart               # Definisi rute aplikasi
├── core/                              # Shared resources dan utilities
│   ├── constants/
│   │   ├── app_colors.dart          # Palet warna aplikasi
│   │   ├── app_strings.dart         # String constants
│   │   └── enums.dart               # Enum definitions
│   ├── theme/
│   │   └── app_theme.dart           # Konfigurasi tema global
│   ├── utils/
│   │   ├── formatters.dart          # Formatter utilities
│   │   ├── helpers.dart             # Helper functions
│   │   └── navigation_helper.dart   # Navigation utilities
│   └── widgets/                      # Reusable widgets
│       ├── custom_appbar.dart       # Custom AppBar
│       ├── custom_button.dart       # Custom button component
│       ├── custom_navbar.dart       # Custom navigation bar
│       ├── custom_textfield.dart    # Custom text input field
│       └── loading_indicator.dart   # Loading indicator widget
│
└── features/                          # Feature-based modules
    ├── auth/                          # Authentication
    │   ├── data/
    │   │   ├── auth_dummy.dart
    │   │   └── user_service.dart
    │   ├── models/
    │   │   └── user_model.dart
    │   ├── views/
    │   │   ├── login_page.dart
    │   │   ├── register_page.dart
    │   │   └── signin_page.dart
    │   └── widgets/
    │       ├── auth_text_field.dart
    │       └── social_login_button.dart
    │
    ├── cart/                         # Shopping cart
    │   ├── data/
    │   ├── models/
    │   ├── tile_widget/
    │   └── views/
    │
    ├── chat/                         # Chat & messaging
    │   ├── data/
    │   ├── models/
    │   └── views/
    │
    ├── checkout/                     # Checkout process
    │   ├── data/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    ├── events/                       # Events listing & details
    │   ├── data/
    │   ├── models/
    │   └── views/
    │
    ├── home/                         # Home screen
    │   ├── home_page.dart
    │   └── special_offers_page.dart
    │
    ├── orders/                       # Order history & tracking
    │   ├── data/
    │   ├── models/
    │   └── views/
    │
    ├── product/                      # Product catalog & details
    │   ├── data/
    │   │   └── product_dummy.dart
    │   ├── models/
    │   │   └── product_model.dart
    │   ├── views/
    │   │   └── product_detail_page.dart
    │   └── widgets/
    │       └── product_card.dart
    │
    ├── profile/                      # User profile
    │   ├── views/
    │   └── widgets/
    │
    ├── search/                       # Product search
    │   ├── models/
    │   ├── views/
    │   └── widgets/
    │
    └── welcome/                      # Welcome screens
        ├── splash_page.dart
        ├── welcome_page1.dart
        ├── welcome_page2.dart
        └── welcome_page3.dart
```

### Struktur Proyek Global
- `assets/` — gambar dan aset statis (lihat `assets/`)
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` — folder platform native
- `pubspec.yaml` — deklarasi dependensi dan aset ([pubspec.yaml](pubspec.yaml))
- `test/` — unit dan widget tests

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
