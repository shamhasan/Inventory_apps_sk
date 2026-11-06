# 📦 Inventory BLoC — Benchmark & Performance Analysis App

Aplikasi mobile berbasis **Flutter** yang mengimplementasikan **Clean Architecture** dan **BLoC (Business Logic Component)** sebagai state management. Proyek ini dikembangkan secara khusus sebagai instrumen penelitian **Skripsi / Tugas Akhir** untuk menganalisis dan mengukur performa aplikasi mobile (*memory usage, CPU usage, rendering / frame rate, dan execution time*) pada pemrosesan dataset inventaris produk dalam jumlah besar (*10.000 records*).

---

## 🎓 Ringkasan Proyek Skripsi

* **Topik Penelitian**: Analisis Komparasi Performa State Management / Arsitektur pada Flutter (Studi Kasus: Pengolahan Dataset Inventaris Produk Lokal).
* **State Management**: [BLoC (`flutter_bloc`)](https://pub.dev/packages/flutter_bloc)
* **Pola Arsitektur**: Clean Architecture (*Domain Layer*, *Data Layer*, *Presentation Layer*)
* **Penyimpanan Lokal**: SQLite via [`sqflite`](https://pub.dev/packages/sqflite) dengan *database seeding* 10.000 data produk inventaris.
* **Instrumen Pengujian**: 
  - *Automated Stress Test / UI Benchmark* via `integration_test`
  - Dart DevTools (*CPU Profiler, Memory Profiler, Performance Timeline*)
  - Android Profiler (Android Studio)

---

## 🏛️ Arsitektur Proyek

Proyek ini menerapkan prinsip pemisahan tanggung jawab (*Separation of Concerns*) dengan struktur direktori sebagai berikut:

```
lib/
├── features/
│   └── product/
│       ├── data/
│       │   ├── datasources/       # ProductLocalDataSource (SQLite, seeding 10.000 data)
│       │   ├── models/            # ProductModel (konversi toMap & fromMap)
│       │   └── repositories/      # ProductRepositoryImpl
│       ├── domain/
│       │   ├── entities/          # ProductEntity
│       │   ├── repositories/      # ProductRepository (kontrak antarmuka)
│       │   └── usecases/          # GetProducts, SortProducts, FilterProducts
│       └── presentation/
│           ├── bloc/              # ProductBloc, ProductEvent, ProductState
│           └── pages/             # ProductPage (antarmuka UI & tombol benchmark)
└── main.dart                      # Dependency injection & inisialisasi MultiBlocProvider
```

---

## 🧪 Skenario Pengujian Benchmark

Pengujian dilakukan untuk menguji efisiensi pengelolaan state dan rendering UI saat menangani 10.000 data dengan skenario:

1. **Jeda Awal (Warm-up / Baseline)**: Masa hening (idle) untuk kalibrasi baseline penggunaan CPU dan Memory.
2. **Operasi Load**: Mengambil seluruh 10.000 produk dari SQLite dan merender ke layar.
3. **Operasi Sort**: Mengurutkan seluruh dataset berdasarkan nama, harga, atau stok.
4. **Operasi Filter**: Memfilter produk aktif/kategori tertentu dan memperbarui state tampilan.

Skenario otomatis tersedia pada file:
```
integration_test/performance_test.dart
```

---

## 🚀 Cara Menjalankan Aplikasi

> **PENTING UNTUK PROFILING / SKRIPSI:**  
> Untuk pengambilan data performa yang valid, **JANGAN** menggunakan mode *Debug* karena mengandung overhead debugging dan *JIT (Just-In-Time) compilation*. Selalu gunakan **Mode Profile** pada **perangkat fisik (Real Device)** dengan kabel USB dan USB Debugging aktif.

### 1. Menjalankan Aplikasi dalam Mode Profile

#### Cek Perangkat yang Terhubung:
```bash
flutter devices
```

#### Jalankan di Mode Profile:
```bash
# Jika hanya ada 1 perangkat yang terhubung:
flutter run --profile

# Jika ada beberapa perangkat, spesifikasikan ID perangkat:
flutter run --profile -d <DEVICE_ID>
```

---

### 2. Menjalankan Integration Test Otomatis dalam Mode Profile

Untuk menjalankan skenario otomatisasi repetisi benchmark:
```bash
flutter test integration_test/performance_test.dart --profile -d <DEVICE_ID>
```

---

### 3. Menggunakan Dart DevTools untuk Profiling

Ketika aplikasi berjalan dalam mode profile, terminal akan menampilkan tautan DevTools:
```text
The Flutter DevTools debugger and profiler is available at:
http://127.0.0.1:9100?uri=http://127.0.0.1:xxxxx/...
```

Buka URL tersebut di browser (atau via Android Studio / VS Code) untuk memantau:
* **Performance Tab**: Analisis frame rate (FPS), UI thread jank, dan GPU rasterizer.
* **CPU Profiler Tab**: Analisis thread activity dan bottleneck fungsi pemrosesan data.
* **Memory Tab**: Analisis alokasi heap Dart, deteksi memory leak, dan snapshot footprint memori.

---

## ⚙️ Persyaratan Sistem & Dependensi

* **Flutter SDK**: `^3.9.0` (Dart SDK kompatibel)
* **Dependencies Utama**:
  * `flutter_bloc: ^9.1.1`
  * `sqflite: ^2.4.2`
  * `intl: ^0.20.3`
* **Dev Dependencies**:
  * `integration_test` (Flutter SDK)
  * `flutter_test` (Flutter SDK)
