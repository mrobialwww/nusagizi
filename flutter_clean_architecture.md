# Flutter Clean Architecture — Nusagizi Development Guide

> Dokumen ini adalah panduan resmi pengembangan fitur di aplikasi **Nusagizi**.
> Setiap fitur baru **wajib** mengikuti pola yang didefinisikan di sini.
> Panduan ini diturunkan langsung dari implementasi nyata di `lib/features/onboarding/`.

---

## Daftar Isi

1. [Filosofi Inti](#1-filosofi-inti)
2. [Struktur Direktori](#2-struktur-direktori)
3. [Lapisan Arsitektur](#3-lapisan-arsitektur)
4. [Core — Shared Foundation](#4-core--shared-foundation)
5. [Dependency Injection (GetIt)](#5-dependency-injection-getit)
6. [Alur Data Lengkap](#6-alur-data-lengkap)
7. [Konvensi Penamaan](#7-konvensi-penamaan)
8. [Aturan Wajib](#8-aturan-wajib)
9. [Checklist Fitur Baru](#9-checklist-fitur-baru)

---

## 1. Filosofi Inti

Arsitektur ini dibangun di atas tiga prinsip utama:

| Prinsip | Arti |
|---|---|
| **Separation of Concerns** | Setiap lapisan hanya mengetahui tugasnya sendiri. UI tidak tahu HTTP. Domain tidak tahu Flutter. |
| **Dependency Rule** | Ketergantungan hanya boleh mengarah ke dalam (Presentation → Domain ← Data). Domain tidak boleh mengimpor apapun dari layer lain. |
| **Testability** | Setiap bagian dapat di-unit test secara mandiri karena bergantung pada abstraksi (abstract class), bukan implementasi konkret. |

---

## 2. Struktur Direktori

Setiap fitur baru dibuat dalam folder `lib/features/<nama_fitur>/` dengan struktur ini:

```
lib/
├── core/
│   ├── di/
│   │   └── service_locator.dart   # GetIt registration (tambahkan registrasi fitur baru di sini)
│   ├── error/
│   │   ├── exceptions.dart        # ServerException, CacheException, NetworkException
│   │   └── failures.dart          # ServerFailure, CacheFailure, NetworkFailure
│   ├── usecase/
│   │   └── usecase.dart           # Base UseCase<Type, Params> abstract class
│   └── ...
│
└── features/
    └── <feature_name>/
        ├── data/
        │   ├── datasources/
        │   │   ├── <feature>_service.dart          # Abstract + Impl untuk Remote (Dio/API)
        │   │   └── <feature>_local_service.dart    # Abstract + Impl untuk Local (SharedPrefs)
        │   ├── models/
        │   │   └── <feature>_model.dart            # DTO untuk request/response JSON
        │   └── repositories/
        │       └── <feature>_repository_impl.dart  # Implementasi dari domain repository
        │
        ├── domain/
        │   ├── entities/                           # (Opsional) Pure Dart objects
        │   ├── repositories/
        │   │   └── <feature>_repository.dart       # Abstract contract (interface)
        │   └── usecases/
        │       └── <action>_usecase.dart           # Satu file per satu aksi bisnis
        │
        └── presentation/
            ├── cubit/
            │   ├── <feature>_cubit.dart
            │   └── <feature>_state.dart
            ├── pages/
            │   └── <feature>_page.dart
            └── widgets/                            # (Opsional) Widget reusable
```

---

## 3. Lapisan Arsitektur

### 3.1 Domain Layer

**Aturan Emas:** Domain layer adalah inti murni bisnis. **Tidak boleh** mengimpor package Flutter maupun library eksternal apapun (Dio, SharedPreferences, dll). Hanya boleh bergantung pada `dartz` untuk tipe `Either`.

#### Domain Repository (Abstract Contract)

File ini mendefinisikan kontrak (interface) apa yang bisa dilakukan oleh sebuah fitur.

```dart
// lib/features/onboarding/domain/repositories/onboarding_repository.dart

import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';

abstract class OnboardingRepository {
  /// Kirimkan role yang dipilih ke backend dan simpan secara lokal.
  Future<Either<Failure, void>> submitRole(String role);
}
```

> **Kenapa `Either<Failure, T>`?**
> Merepresentasikan dua kemungkinan hasil: `Left` (gagal) atau `Right` (sukses).
> Ini memaksa pemanggil untuk selalu menangani kedua kasus secara eksplisit, tanpa perlu try/catch di level atas.

#### Use Case

Setiap aksi bisnis tunggal memiliki satu Use Case class. Gunakan `NoParams` jika tidak ada parameter. 
**PENTING:** Seluruh *Business Logic* (misalnya penentuan status "Lulus/Gagal" berdasarkan skor, perhitungan algoritma, dsb.) WAJIB diletakkan di dalam Use Case, bukan di Repository (Data Layer). Repository murni hanya bertugas mengambil dan me- *mapping* data (dari Model menjadi Entity mentah).

```dart
// lib/features/onboarding/domain/usecases/submit_role_usecase.dart

class SubmitRoleUseCase implements UseCase<void, String> {
  final OnboardingRepository repository;
  SubmitRoleUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.submitRole(params);
  }
}
```

---

### 3.2 Data Layer

#### Model (DTO)

Model digunakan untuk serialisasi/deserialisasi JSON. Bukan representasi bisnis, hanya data transport.

```dart
// lib/features/onboarding/data/models/onboarding_model.dart

class OnboardingModel {
  final String role;
  OnboardingModel({required this.role});

  Map<String, dynamic> toJson() => {'role': role};

  // Tambahkan jika perlu memetakan response:
  // factory OnboardingModel.fromJson(Map<String, dynamic> json) { ... }
}
```

#### Data Source (Abstract + Impl dalam satu file)

```dart
// lib/features/onboarding/data/datasources/onboarding_service.dart

// 1. Abstract contract
abstract class OnboardingService {
  Future<void> submitOnboarding(OnboardingModel data);
  Future<Credentials> refreshToken();
}

// 2. Concrete implementation
class OnboardingServiceImpl implements OnboardingService {
  final Auth0 auth0;
  final Dio _dio = Dio();
  OnboardingServiceImpl({required this.auth0});

  @override
  Future<void> submitOnboarding(OnboardingModel data) async {
    try {
      await _dio.post('/onboarding', data: data.toJson());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
```

> **Penting:** Data source **melempar `Exception`**, bukan `Failure`.
> Konversi dari Exception ke Failure dilakukan sepenuhnya di `RepositoryImpl`.

#### Repository Implementation

```dart
// lib/features/onboarding/data/repositories/onboarding_repository_impl.dart

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingService remoteDataSource;
  final OnboardingLocalService localDataSource;

  OnboardingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> submitRole(String role) async {
    try {
      await remoteDataSource.submitOnboarding(OnboardingModel(role: role));
      await localDataSource.cacheSelectedRole(role);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
```

---

### 3.3 Presentation Layer

#### State

Definisikan semua kemungkinan state. Gunakan `Equatable` agar BlocBuilder tidak rebuild jika nilai state sama.

```dart
// lib/features/onboarding/presentation/cubit/onboarding_state.dart

abstract class OnboardingState extends Equatable {
  const OnboardingState();
  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}
class OnboardingLoading extends OnboardingState {}

class OnboardingSuccess extends OnboardingState {
  final String role;
  const OnboardingSuccess({required this.role});
  @override
  List<Object> get props => [role];
}

class OnboardingError extends OnboardingState {
  final String message;
  const OnboardingError({required this.message});
  @override
  List<Object> get props => [message];
}
```

#### Cubit

Cubit adalah controller UI. Memanggil Use Case dan mengubah hasilnya menjadi State.

```dart
// lib/features/onboarding/presentation/cubit/onboarding_cubit.dart

class OnboardingCubit extends Cubit<OnboardingState> {
  final SubmitRoleUseCase submitRoleUseCase;
  OnboardingCubit({required this.submitRoleUseCase}) : super(OnboardingInitial());

  Future<void> submitRole(String role) async {
    emit(OnboardingLoading());
    final result = await submitRoleUseCase(role);
    // result.fold() memaksa kita menangani KEDUA kasus: gagal (left) dan sukses (right)
    result.fold(
      (failure) => emit(OnboardingError(message: failure.message)),
      (_) => emit(OnboardingSuccess(role: role)),
    );
  }
}
```

#### Page

```dart
// lib/features/onboarding/presentation/pages/select_role_page.dart

class SelectRolePage extends StatefulWidget {
  const SelectRolePage({super.key});
  @override
  State<SelectRolePage> createState() => _SelectRolePageState();
}

class _SelectRolePageState extends State<SelectRolePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(), // Ambil dari service locator
      child: Builder(
        builder: (context) {
          return BlocConsumer<OnboardingCubit, OnboardingState>(
            listener: (context, state) {
              // Side effects SAJA: navigasi, SnackBar — BUKAN rebuild UI
              if (state is OnboardingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              // Rebuild UI berdasarkan state
              final isLoading = state is OnboardingLoading;
              return Scaffold(/* ... */);
            },
          );
        },
      ),
    );
  }
}
```

---

## 4. Core — Shared Foundation

### `core/error/exceptions.dart`
```dart
class ServerException implements Exception { final String message; const ServerException({required this.message}); }
class CacheException implements Exception { final String message; const CacheException({required this.message}); }
class NetworkException implements Exception { final String message; const NetworkException({required this.message}); }
```
**Aturan:** Data source hanya boleh melempar exception dari file ini.

### `core/error/failures.dart`
```dart
abstract class Failure { final String message; const Failure({required this.message}); }
class ServerFailure extends Failure { const ServerFailure({required super.message}); }
class CacheFailure extends Failure { const CacheFailure({required super.message}); }
class NetworkFailure extends Failure { const NetworkFailure({required super.message}); }
```
**Aturan:** Repository hanya boleh mengembalikan Failure dari file ini (dibungkus `Left(...)`).

### `core/usecase/usecase.dart`
```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
class NoParams {} // Untuk use case tanpa parameter
```

---

## 5. Dependency Injection (GetIt)

Semua registrasi dilakukan di satu file terpusat: `lib/core/di/service_locator.dart`.

**Urutan registrasi (dari bawah ke atas):**
1. External dependencies (SharedPreferences, Auth0)
2. Data Sources
3. Repositories
4. Use Cases
5. Cubits

```dart
// Data Sources & Repositories → lazySingleton (dibuat sekali, dipakai berulang)
sl.registerLazySingleton<OnboardingService>(
  () => OnboardingServiceImpl(auth0: sl<Auth0>()),
);
sl.registerLazySingleton<OnboardingRepository>(
  () => OnboardingRepositoryImpl(
    remoteDataSource: sl<OnboardingService>(),
    localDataSource: sl<OnboardingLocalService>(),
  ),
);

// Use Cases → lazySingleton (stateless, aman untuk singleton)
sl.registerLazySingleton<SubmitRoleUseCase>(
  () => SubmitRoleUseCase(repository: sl<OnboardingRepository>()),
);

// Cubits → registerFactory (dibuat BARU setiap kali dipanggil, karena menyimpan state)
sl.registerFactory<OnboardingCubit>(
  () => OnboardingCubit(submitRoleUseCase: sl<SubmitRoleUseCase>()),
);
```

> **`registerFactory` vs `registerLazySingleton`:**
> - **`registerFactory`**: Instance **baru** setiap `sl<T>()` dipanggil. **Wajib untuk Cubit/Bloc.**
> - **`registerLazySingleton`**: Instance **sama** (dibuat pertama kali saat dipanggil). Cocok untuk Services, Repositories, Use Cases yang stateless.

---

## 6. Alur Data Lengkap

```
User Tap Button
      |
      v
[Page] context.read<FeatureCubit>().someAction(params)
      |
      v
[Cubit] emit(Loading) --> calls SomeUseCase(params)
      |
      v
[UseCase] delegates to FeatureRepository.someMethod(params)
      |
      v
[RepositoryImpl] calls RemoteDataSource / LocalDataSource
      |
      v
[DataSource] HTTP call / local storage
             (throws ServerException / CacheException on failure)
      |
      v
[RepositoryImpl] catches Exception
              --> returns Left(SomeFailure)  OR  Right(data)
      |
      v
[UseCase] returns Either<Failure, T> as-is to Cubit
      |
      v
[Cubit] result.fold(
  (failure) => emit(FeatureError(failure.message)),
  (data)    => emit(FeatureSuccess(data)),
)
      |
      v
[Page] BlocConsumer:
  listener --> navigate / show SnackBar
  builder  --> rebuild UI with new state
```

---

## 7. Konvensi Penamaan

| Komponen | Konvensi | Contoh |
|---|---|---|
| Feature folder | `snake_case` | `user_profile/` |
| Data Source Abstract | `FeatureService` | `OnboardingService` |
| Data Source Impl | `FeatureServiceImpl` | `OnboardingServiceImpl` |
| Local Data Source | `FeatureLocalService` / `FeatureLocalServiceImpl` | `OnboardingLocalService` |
| Model (DTO) | `FeatureModel` | `OnboardingModel` |
| Repository Abstract | `FeatureRepository` | `OnboardingRepository` |
| Repository Impl | `FeatureRepositoryImpl` | `OnboardingRepositoryImpl` |
| Use Case | `ActionFeatureUseCase` | `SubmitRoleUseCase`, `GetUserUseCase` |
| Cubit | `FeatureCubit` | `OnboardingCubit` |
| State | `FeatureState` + turunannya | `OnboardingSuccess` |
| Page | `DescriptionPage` | `SelectRolePage` |
| Widget | `description_widget.dart` | `role_card_widget.dart` |
| File | `snake_case.dart` | `submit_role_usecase.dart` |

---

## 8. Aturan Wajib

Aturan ini **tidak boleh dilanggar** tanpa diskusi dan alasan yang sangat kuat.

1. **Domain layer bebas dari dependency eksternal.** Tidak ada `import 'package:dio/...'` atau `import 'package:flutter/...'` di folder `domain/`.

2. **Data source hanya melempar Exception, bukan Failure.** Konversi dilakukan di `RepositoryImpl`.

3. **Repository selalu mengembalikan `Either<Failure, T>`.** Tidak ada `throw` yang merembes ke Cubit.

4. **Cubit tidak boleh mengimpor library HTTP/IO secara langsung.** Semua akses data melalui Use Case.

5. **Cubit didaftarkan dengan `registerFactory`** di service locator, bukan `registerLazySingleton`.

6. **Setiap Use Case hanya melakukan satu tanggung jawab** (Single Responsibility Principle).

7. **Semua Business Logic WAJIB berada di Domain Layer (Use Case/Entity).** Repository murni hanya bertugas sebagai pipa pengambil dan pemeta data. Keputusan logika (seperti memetakan skor angka menjadi status *string*) tidak boleh ada di Repository.

8. **Widget UI bersifat "Dumb Component"** sebisa mungkin. Logic state dan navigasi dikelola oleh Cubit/Page, bukan widget kecil. Kirimkan callback jika widget perlu memicu aksi.

8. **Semua dependency baru didaftarkan di `service_locator.dart`**, bukan diinstansiasi langsung di dalam class yang memakainya.

---

## 9. Checklist Fitur Baru

Gunakan checklist ini setiap kali membuat fitur baru dari awal.

### Domain Layer
- [ ] `domain/repositories/<feature>_repository.dart` — abstract class
- [ ] `domain/usecases/<action>_usecase.dart` — satu file per aksi bisnis
- [ ] (Opsional) `domain/entities/<feature>_entity.dart`

### Data Layer
- [ ] `data/models/<feature>_model.dart` — dengan `toJson()` dan/atau `fromJson()`
- [ ] `data/datasources/<feature>_service.dart` — abstract + impl
- [ ] (Opsional) `data/datasources/<feature>_local_service.dart` — abstract + impl
- [ ] `data/repositories/<feature>_repository_impl.dart` — implements domain repository, Exception ke Failure

### Presentation Layer
- [ ] `presentation/cubit/<feature>_state.dart` — Initial/Loading/Success/Error
- [ ] `presentation/cubit/<feature>_cubit.dart` — extends Cubit, inject Use Cases
- [ ] `presentation/pages/<description>_page.dart` — BlocProvider + BlocConsumer
- [ ] (Opsional) widget-widget di `presentation/widgets/`

### Dependency Injection
- [ ] Daftarkan DataSource dengan `registerLazySingleton`
- [ ] Daftarkan Repository dengan `registerLazySingleton`
- [ ] Daftarkan setiap UseCase dengan `registerLazySingleton`
- [ ] Daftarkan Cubit dengan `registerFactory`

### Routing
- [ ] Tambahkan route baru di `router.dart`
- [ ] Daftarkan nama route di `AppRoutes` enum jika ada
