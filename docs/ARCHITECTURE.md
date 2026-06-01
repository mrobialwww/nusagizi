# 🏗️ NusaGizi — Arsitektur Aplikasi

> Dokumentasi ini mendeskripsikan pola *Clean Architecture* yang diterapkan pada proyek Flutter **NusaGizi**, beserta konvensi penamaan, tanggung jawab tiap lapisan, dan panduan penambahan fitur baru.

---

## 📐 Gambaran Umum

Proyek ini menerapkan **Clean Architecture** yang dipopulerkan oleh *Uncle Bob (Robert C. Martin)*, yang dipadukan dengan pendekatan **Feature-First** untuk memisahkan kode berdasarkan domain bisnis.

Tujuannya adalah:
- ✅ Memisahkan kepentingan (*Separation of Concerns*)
- ✅ Kode mudah diuji (*Testable*)
- ✅ Kode mudah di-*scale* saat fitur bertambah
- ✅ *Business logic* tidak bergantung pada *framework* (Flutter, API, dsb)

Aturan utama: **Ketergantungan hanya boleh mengarah ke dalam.** Lapisan luar boleh bergantung pada lapisan dalam, tetapi tidak sebaliknya.

```
┌─────────────────────────────────────┐
│        PRESENTATION LAYER           │  ← Bergantung pada Domain
│   (Pages, Widgets, Cubit/BLoC)      │
├─────────────────────────────────────┤
│          DOMAIN LAYER               │  ← Murni Dart, tidak bergantung siapapun
│   (Entities, UseCases, Repo. Contracts) │
├─────────────────────────────────────┤
│           DATA LAYER                │  ← Bergantung pada Domain
│   (Models, DataSources, Repo. Impl) │
└─────────────────────────────────────┘
```

---

## 📁 Struktur Direktori

```
lib/
├── main.dart
│
├── core/                        # Kode bersama lintas fitur
│   ├── config/
│   │   ├── assets/              # Konstanta path aset (gambar, vektor)
│   │   │   ├── app_images.dart
│   │   │   └── app_vectors.dart
│   │   ├── routes/              # Definisi router aplikasi
│   │   │   └── app_router.dart
│   │   └── themes/              # Tema visual aplikasi
│   │
│   ├── constants/               # Data dummy/statis sementara (sebelum API)
│   │   ├── child_data_dummy.dart
│   │   ├── dummy_child_development_summaries.dart
│   │   └── kpsp_dummy_data.dart
│   │
│   ├── di/                      # Dependency Injection
│   │   └── injection_container.dart
│   │
│   ├── domain/                  # Entity global lintas fitur
│   │   └── entities/
│   │       ├── child_data.dart
│   │       ├── child_development_summary.dart
│   │       ├── child_entity.dart
│   │       ├── child_profile.dart
│   │       └── growth_record.dart
│   │
│   ├── error/                   # Abstraksi error & exception
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   │
│   ├── network/                 # Konfigurasi HTTP client
│   ├── usecase/                 # Base class UseCase generik
│   │   └── usecase.dart
│   │
│   ├── utils/                   # Helper & extension umum
│   └── widgets/                 # Widget UI yang dipakai lintas fitur
│       ├── app_card.dart
│       └── header_growth_development.dart
│
├── common/                      # (Kosong — siap digunakan)
│
└── features/                    # Kode spesifik per fitur/domain
    ├── auth/
    ├── development/             # ← Fitur utama yang sudah dikerjakan
    ├── growth/
    ├── home/
    ├── nutrition/
    ├── onboarding/
    ├── profile/
    ├── splash/
    └── todos/
```

---

## 🧩 Anatomi Satu Fitur

Setiap fitur (misal: `development`) dibagi menjadi **tiga sub-lapisan**:

```
features/development/
├── data/                        # DATA LAYER
│   ├── datasources/             # Sumber data: API remote / SQLite local
│   ├── models/                  # DTO (Data Transfer Object) + fromJson/toJson
│   └── repositories/            # Implementasi konkret dari kontrak domain
│
├── domain/                      # DOMAIN LAYER
│   ├── entities/                # Objek bisnis murni Dart (tanpa toJson dsb)
│   ├── repositories/            # Kontrak/interface repository (abstract class)
│   └── usecases/                # Satu use case = satu aksi bisnis
│
└── presentation/                # PRESENTATION LAYER
    ├── cubit/                   # State Management (Cubit/BLoC)
    ├── pages/                   # Halaman penuh (satu screen = satu file)
    └── widgets/                 # Widget UI yang dapat dipakai ulang
```

---

## 🔵 Domain Layer — Inti Bisnis

> **Aturan:** Folder ini **DILARANG** meng-import `package:flutter/material.dart` atau paket apapun selain `dartz` (untuk `Either`). Ini adalah murni Dart.

### Entities
Objek bisnis sederhana yang merepresentasikan konsep dalam domain.

**Contoh — `kpsp_domain.dart`:**
```dart
/// Domain kategori soal KPSP
enum KpspDomain {
  motorikKasar,
  motorikHalus,
  bicaraBahasa,
  sosialisasiKemandirian;

  String get label { /* ... */ }
}
```

**Contoh — `kpsp_question.dart`:**
```dart
class KpspQuestion {
  final String id;
  final String question;
  final KpspDomain domain;
  // ...
}
```

**Entity global (di `core/domain/entities/`):**

| File | Deskripsi |
|---|---|
| `child_profile.dart` | Profil dasar anak (nama, tanggal lahir) |
| `child_data.dart` | Gabungan profil + riwayat pertumbuhan |
| `child_development_summary.dart` | Rangkuman hasil perkembangan untuk ditampilkan di UI |
| `growth_record.dart` | Satu data pengukuran pertumbuhan (BB/TB/LK) |

### Repository Contracts (Interfaces)
*Abstract class* yang mendefinisikan **apa** yang bisa dilakukan, tanpa peduli **bagaimana** implementasinya.

```dart
// domain/repositories/kpsp_repository.dart
abstract class KpspRepository {
  Future<Either<Failure, List<KpspQuestion>>> getQuestions(String childAge);
}
```

### Use Cases
Satu *use case* = satu operasi bisnis tunggal. Mengikuti base class di `core/usecase/usecase.dart`:

```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
```

---

## 🟡 Data Layer — Implementasi

> **Aturan:** Layer ini boleh bergantung pada Domain, tetapi Domain tidak boleh bergantung pada Data.

### Models (DTO)
Versi "sadar-JSON" dari *Entity*. Mewarisi *Entity* dan menambahkan method `fromJson` / `toJson`.

```dart
// data/models/kpsp_question_model.dart
class KpspQuestionModel extends KpspQuestion {
  factory KpspQuestionModel.fromJson(Map<String, dynamic> json) { /* ... */ }
  Map<String, dynamic> toJson() { /* ... */ }
}
```

### DataSources
Bertanggung jawab melakukan panggilan API atau akses *database* lokal secara langsung.

```dart
abstract class KpspRemoteDataSource {
  Future<List<KpspQuestionModel>> getQuestions(String childAge);
}
```

### Repository Implementations
Mengimplementasikan kontrak yang didefinisikan di *Domain Layer*, menggunakan `DataSource` dan mengubah `Exception` menjadi `Failure`.

```dart
class KpspRepositoryImpl implements KpspRepository {
  final KpspRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<KpspQuestion>>> getQuestions(String childAge) async {
    try {
      final result = await remoteDataSource.getQuestions(childAge);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
```

---

## 🟢 Presentation Layer — UI

> **Aturan:** Layer ini boleh bergantung pada Domain (melalui *Cubit*), tetapi tidak boleh langsung mengakses *Data Layer*.

### Cubit / BLoC (State Management)
Jembatan antara UI dan *Domain Layer*. Memanggil *UseCase* dan mengubah hasilnya menjadi *State* yang siap dikonsumsi UI.

```dart
// presentation/cubit/kpsp_cubit.dart
class KpspCubit extends Cubit<KpspState> {
  final GetKpspQuestions getKpspQuestions;

  Future<void> loadQuestions(String childAge) async {
    emit(KpspLoading());
    final result = await getKpspQuestions(Params(childAge: childAge));
    result.fold(
      (failure) => emit(KpspError(failure.message)),
      (questions) => emit(KpspLoaded(questions)),
    );
  }
}
```

> ⚠️ **Catatan Saat Ini:** Fitur `development` belum menggunakan Cubit secara penuh karena masih menggunakan data *dummy*. Folder `cubit/` telah disiapkan dan akan diisi saat integrasi API dilakukan.

### Pages
Satu file = satu halaman penuh (satu *route*). Halaman menerima parameter yang dibutuhkan melalui *constructor* dan mendelegasikan logika ke Cubit.

**Halaman yang tersedia di fitur `development`:**

| File | Deskripsi |
|---|---|
| `development_page.dart` | Halaman utama dashboard perkembangan anak |
| `development_profile_detail_page.dart` | Detail profil perkembangan per domain |
| `development_history_page.dart` | Riwayat aktivitas dan hasil asesmen |
| `kpsp_assessment_page.dart` | Alur pengisian soal KPSP satu per satu |
| `kpsp_result_page.dart` | Hasil dan rekomendasi setelah asesmen KPSP |
| `checklist_milestone_page.dart` | Checklist milestone tumbuh kembang manual |

### Widgets
Komponen UI yang dapat dipakai ulang (*reusable*) di dalam satu fitur.

**Widget di fitur `development`:**

| File | Deskripsi |
|---|---|
| `development_profile_card.dart` | Kartu ringkasan profil + radar chart kecil |
| `development_radar_chart.dart` | Radar chart yang dapat dikonfigurasi (DRY widget) |
| `development_summary_card.dart` | Kartu status badge + skor KPSP |
| `history_timeline_card.dart` | Item kartu untuk tampilan timeline riwayat |

**Widget global (di `core/widgets/`):**

| File | Deskripsi |
|---|---|
| `header_growth_development.dart` | Header bersama (picker anak + tombol riwayat) |
| `app_card.dart` | Komponen kartu dasar yang dapat dipakai ulang |

---

## ⚙️ Core — Infrastruktur Lintas Fitur

### Error Handling

Menggunakan pola **Exception → Failure** berbasis `dartz`:

```
Exception (Data Layer)  →  Failure (Domain Layer)  →  UI Error State
```

```dart
// core/error/exceptions.dart
class ServerException implements Exception {}
class CacheException implements Exception {}

// core/error/failures.dart
abstract class Failure { final String message; }
class ServerFailure extends Failure {}
class CacheFailure extends Failure {}
```

### Dependency Injection

`core/di/injection_container.dart` menggunakan `get_it` untuk mendaftarkan semua dependensi (DataSources, Repositories, UseCases, Cubits).

### Data Dummy / Konstanta Sementara

Selama API belum tersedia, data statis diletakkan di `core/constants/`:

| File | Deskripsi |
|---|---|
| `child_data_dummy.dart` | Data profil anak & riwayat pertumbuhan dummy |
| `kpsp_dummy_data.dart` | Soal-soal KPSP dummy per kelompok usia |
| `dummy_child_development_summaries.dart` | Rangkuman perkembangan dummy |

> 💡 **Rencana Migrasi:** Saat API tersedia, file-file di `core/constants/` akan **dihapus** dan digantikan oleh implementasi `DataSource` → `Repository` → `UseCase` yang sesungguhnya. Logika kalkulasi (skor, status, rekomendasi) yang saat ini ada di UI (`kpsp_result_page.dart`) akan dipindah ke *Backend* dan hanya hasilnya yang dikonsumsi UI.

---

## 🔗 Alur Data (Data Flow)

### Kondisi Saat Ini (Prototype / Dummy Data)
```
core/constants/ (dummy)
       │
       ▼
  Presentation Page
  (kalkulasi skor & UI helper ada di sini, sementara)
       │
       ▼
  Widget Rendering
```

### Target Setelah Integrasi API
```
  REST API / Backend
       │
       ▼
  DataSource (HTTP call)
       │
       ▼  (Either<Exception, Model>)
  Repository Implementation
       │
       ▼  (Either<Failure, Entity>)
  UseCase
       │
       ▼  (Either<Failure, Entity>)
  Cubit → emit(State)
       │
       ▼
  Page (BlocBuilder) → Widget Rendering
```

---

## ✅ Konvensi & Aturan Penamaan

| Jenis | Konvensi | Contoh |
|---|---|---|
| Entity | `PascalCase`, nama benda | `KpspQuestion`, `ChildProfile` |
| Model (DTO) | `[Entity]Model` | `KpspQuestionModel` |
| Repository Contract | `[Feature]Repository` | `KpspRepository` |
| Repository Impl | `[Feature]RepositoryImpl` | `KpspRepositoryImpl` |
| UseCase | Kata kerja + kata benda | `GetKpspQuestions`, `SubmitKpspAnswers` |
| DataSource (abstract) | `[Feature]RemoteDataSource` | `KpspRemoteDataSource` |
| DataSource (impl) | `[Feature]RemoteDataSourceImpl` | `KpspRemoteDataSourceImpl` |
| Cubit | `[Feature]Cubit` | `KpspCubit` |
| Page | `[Feature]Page` | `KpspAssessmentPage` |
| Widget (reusable) | Nama deskriptif | `DevelopmentRadarChart` |
| Private widget (lokal) | `_build[Nama]()` (helper method) | `_buildDomainScoreItem()` |
| File | `snake_case` | `kpsp_assessment_page.dart` |

---

## 📋 Panduan Menambah Fitur Baru

1. **Buat folder fitur:** `lib/features/[nama_fitur]/`
2. **Domain Layer terlebih dahulu:**
   - Definisikan *Entity* di `domain/entities/`
   - Buat kontrak *Repository* di `domain/repositories/`
   - Buat *UseCase* di `domain/usecases/`
3. **Data Layer:**
   - Buat *Model* (DTO) di `data/models/`
   - Buat *DataSource* di `data/datasources/`
   - Implementasikan *Repository* di `data/repositories/`
4. **Presentation Layer:**
   - Buat *Cubit* + *State* di `presentation/cubit/`
   - Buat *Page(s)* di `presentation/pages/`
   - Buat *Widgets* di `presentation/widgets/`
5. **Daftarkan dependensi** di `core/di/injection_container.dart`
6. **Tambahkan route** di `core/config/routes/app_router.dart`

---

> 📅 *Dokumentasi ini dibuat pada 31 Mei 2026 dan mencerminkan kondisi arsitektur proyek pada fase prototyping (belum ada integrasi API aktif).*
