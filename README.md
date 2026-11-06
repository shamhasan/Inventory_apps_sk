# Analisis Performa State Management Flutter: Implementasi Riverpod (Studi Kasus Inventaris 10.000 SKU)

[![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Riverpod](https://img.shields.io/badge/State%20Management-Riverpod%20v3.3-00B4D8)](https://riverpod.dev)
[![Database](https://img.shields.io/badge/Database-SQLite%20(sqflite)-003B57?logo=sqlite&logoColor=white)](https://pub.dev/packages/sqflite)
[![Mode](https://img.shields.io/badge/Benchmark-Profile%20Mode-success)](#panduan-menjalankan-benchmark)

Repositori ini merupakan artefak implementasi perangkat lunak untuk penelitian **Skripsi / Tugas Akhir**, yang berfokus pada pengujian dan analisis komparasi performa *state management* **Riverpod** pada aplikasi *mobile* berbasis Flutter dengan beban pengolahan dataset besar (10.000 data inventaris/SKU).

---

## 📌 Informasi Penelitian

- **Topik Penelitian**: Analisis Komparasi Kinerja State Management pada Framework Flutter Menggunakan Data Skala Besar
- **Studi Kasus**: Aplikasi Manajemen Inventaris Produk Retail (*Local Database SQLite*)
- **Subjek Uji**: Implementasi State Management **Riverpod** (*StateNotifier*)
- **Target Komparasi**: Implementasi State Management alternatif (seperti BLoC pada `inventory_bloc`)

---

## 🎯 Tujuan Penelitian

1. Menganalisis efisiensi penggunaan sumber daya perangkat keras (**CPU Usage** dan **Memory/RAM Usage**) pada implementasi Riverpod saat menangani 10.000 item.
2. Mengukur **Waktu Eksekusi (*Execution Time*)** pada operasi kritis manajemen data inventaris:
   - Pemuatan data (*Load Data* dari SQLite ke memori).
   - Pengurutan data (*Sorting* berdasarkan harga termurah).
   - Penyaringan data (*Filtering* produk stok rendah `< 10`).
3. Mengobservasi kestabilan antarmuka pengguna (*UI Frame Rendering / Frame Drop / Jank*) saat melakukan manipulasi *state* secara dinamis.

---

## 🏛️ Arsitektur Aplikasi

Proyek ini menerapkan **Clean Architecture** untuk menjamin *separation of concerns*, konsistensi modularitas, serta independensi logika bisnis terhadap framework UI:

```text
lib/
├── features/
│   └── product/
│       ├── data/
│       │   ├── datasources/        # Akses database SQLite lokal (10k pre-seeded records)
│       │   ├── models/             # Mapping entitas ke Map/SQLite (ProductModel)
│       │   └── repositories/       # Implementasi kontrak repositori
│       ├── domain/
│       │   ├── entities/           # Business entities murni (ProductEntity)
│       │   ├── repositories/       # Abstraksi repositori data
│       │   └── usecases/           # Logika bisnis: GetProducts, SortProducts, FilterProducts
│       └── presentation/
│           ├── pages/              # Antarmuka tampilan (ProductPage)
│           └── providers/          # Riverpod StateNotifier & State definition
└── main.dart                       # Entry point aplikasi terbungkus ProviderScope
```

---

## 🔬 Skenario Pengujian & Metrik Benchmark

### 1. Dataset Uji
- **Jumlah Data**: 10.000 SKU / produk retail.
- **Penyimpanan**: SQLite lokal melalui package `sqflite`.
- **Atribut Produk**: `id`, `sku`, `name`, `description`, `price`, `stock`, `category`, `imageUrl`, `weight`, `isActive`, `createdAt`, `updatedAt`.
- **Seeding Otomatis**: Dilakukan saat inisialisasi basis data pertama kali.

### 2. Skenario Operasi
Pengujian otomatis dijalankan melalui modul **Integration Test** (`integration_test/performance_test.dart`):

| Langkah | Aksi | Deskripsi Beban Komputasi |
|---|---|---|
| **0** | **Stabilisasi Baseline** | Jeda waktu setelah aplikasi terbuka untuk menstabilkan kondisi idle |
| **1** | **Load 10k SKU** | Query 10.000 data dari SQLite, parsing ke Model/Entity, dan pembaruan state |
| **2** | **Sort Harga** | Pengurutan 10.000 data objek di memori dari harga terendah ke tertinggi |
| **3** | **Filter Stok** | Filtering data di memori untuk produk dengan stok `< 10` |
| **4** | **Pencatatan Metrik** | Evaluasi hasil profil melalui DevTools & log Stopwatch |

### 3. Parameter Metrik yang Diukur
1. **Waktu Eksekusi (Execution Time / ms)**:
   - Dicatat via `Stopwatch` dengan tag log khusus: `METRIK Y3 (Riverpod - [Aksi])`.
2. **CPU Profiling (%)**:
   - Total konsumsi siklus CPU dan waktu aktivitas thread Dart/UI melalui Flutter DevTools CPU Profiler.
3. **Alokasi Memori (Memory Heap & RSS / MB)**:
   - Konsumsi memori sebelum eksekusi (*baseline*), lonjakan saat *load 10k*, dan setelah *sort/filter*.
4. **Frame Rendering Performance**:
   - Identifikasi frame jank/raster jank pada rendering `ListView.builder`.

---

## 🛠️ Prasyarat & Instalasi

### Prasyarat Sistem
- **Flutter SDK**: `>= 3.9.0` (disarankan saluran stable)
- **Dart SDK**: `^3.9.0`
- **Android SDK**: API level 21 atau lebih tinggi
- **Perangkat Uji**: Disarankan menggunakan **Perangkat Fisik (Physical Android Device)** dengan mode USB Debugging aktif agar hasil pengujian mencerminkan performa nyata (*bare-metal*).

### Langkah Instalasi

1. **Clone repositori**:
   ```bash
   git clone <url-repositori-anda>
   cd inventory_riverpod
   ```

2. **Unduh dependensi**:
   ```bash
   flutter pub get
   ```

3. **Verifikasi perangkat target**:
   ```bash
   flutter devices
   ```

---

## 🚀 Panduan Menjalankan Benchmark

> [!IMPORTANT]
> Selalu jalankan pengujian benchmark dalam **Profile Mode** (`--profile`). Jangan gunakan **Debug Mode** karena overhead debugging JIT (*Just-In-Time*) dan assertion akan mendistorsi hasil metrik.

### Opsi A: Menggunakan VS Code Run Configuration
Tersedia konfigurasi bawaan pada `.vscode/launch.json`:
1. Buka menu **Run & Debug** (`Ctrl+Shift+D`).
2. Pilih profil: **"Integration Test (Profile Mode)"**.
3. Tekan **F5** untuk memulai.

### Opsi B: Menggunakan Terminal / Command Line

1. **Jalankan tes integrasi otomatis dalam Profile Mode**:
   ```bash
   flutter run --profile integration_test/performance_test.dart -d <DEVICE_ID>
   ```

2. **Prosedur Pengambilan Data**:
   - Setelah aplikasi terpasang dan terbuka pada perangkat, terminal akan menampilkan:
     ```text
     ====================================================
     ⏳ APLIKASI TERBUKA. JEDA PERSIAPAN DIMULAI.
     🚨 BUKA DEVTOOLS DAN KLIK "RECORD" DI CPU PROFILER SEKARANG!
     ====================================================
     ```
   - Buka tautan **Flutter DevTools** yang muncul di terminal pada browser Anda.
   - Buka tab **CPU Profiler** lalu klik **Record**, atau buka tab **Memory** untuk memantau grafik heap.
   - Robot uji akan secara otomatis mengeksekusi operasi **Load 10k**, **Sort**, dan **Filter** dengan interval waktu tertentu.
   - Amati log waktu eksekusi pada console:
     ```text
     METRIK Y3 (Riverpod - Load): xxx.xx ms
     METRIK Y3 (Riverpod - Sort): xxx.xx ms
     METRIK Y3 (Riverpod - Filter): xxx.xx ms
     ```
   - Hentikan *recording* di DevTools dan unduh/catat data profil untuk diolah dalam laporan skripsi.

---

## 📦 Dependensi Utama

| Package | Versi | Fungsi |
|---|---|---|
| [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod) | `^3.3.2` | State management berbasis reactive provider |
| [`riverpod`](https://pub.dev/packages/riverpod) | `^3.3.2` | Core library Riverpod |
| [`sqflite`](https://pub.dev/packages/sqflite) | `^2.4.2` | Akses SQLite lokal database di Android/iOS |
| [`integration_test`](https://api.flutter.dev/flutter/integration_test/integration_test-library.html) | SDK | Otomasi pengujian fungsional & performa perangkat |
| [`intl`](https://pub.dev/packages/intl) | `^0.20.3` | Format mata uang dan tanggal |

---

## 📝 Catatan Metodologi Penelitian

- **Validitas Data**: Untuk meminimalisir bias pengukuran (misal *CPU thermal throttling* atau *Garbage Collection spikes*), disarankan melakukan pengujian sebanyak minimal **$n \ge 30$ kali repetisi** untuk setiap skenario, kemudian menghitung nilai *Mean*, *Median*, dan *Standard Deviation*.
- **Kondisi Perangkat**: Matikan aplikasi latar belakang (*background processes*), gunakan kecerahan layar konstan, dan pastikan baterai perangkat berada di atas 50%.
- **Komparasi**: Pengujian serupa dengan parameter yang sama persis dijalankan pada proyek pembanding (BLoC) untuk menjamin objektivitas penelitian (*fair testing*).

---

## 👤 Peneliti

- **Nama**: [Nama Mahasiswa]
- **NIM**: [Nomor Induk Mahasiswa]
- **Program Studi**: [Teknik Informatika / Sistem Informasi / Ilmu Komputer]
- **Fakultas / Universitas**: [Nama Universitas]
- **Dosen Pembimbing**:
  1. [Nama Pembimbing I]
  2. [Nama Pembimbing II]
