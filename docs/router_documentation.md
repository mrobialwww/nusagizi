# Dokumentasi Routing (GoRouter) Nusagizi

Dokumentasi ini dibuat untuk mempermudah penambahan dan pemahaman rute (routes) di aplikasi Nusagizi menggunakan `go_router`.

## Konsep Dasar

Nusagizi menggunakan pendekatan **Named Routes** melalui `go_router`. Daripada menggunakan `Navigator.push(...)` dengan memanggil widget page secara langsung, kita menggunakan nama rute (misal: `context.goNamed(AppRoutes.growth.name)`).

### Mengapa Menggunakan Named Routes?
1. **Lebih bersih**: Tidak perlu banyak import widget di berbagai file.
2. **Deep linking**: Mempermudah implementasi notifikasi atau deep link dari luar aplikasi.
3. **Pemisahan Logika**: Memisahkan logika navigasi dan UI.

## Struktur `router.dart`

File utama berada di `lib/router.dart`. Terdapat kelas `AppRouter` yang memiliki inisialisasi `GoRouter`.

### 1. Redirect & Middleware (Auth Guard)

Di dalam `GoRouter`, terdapat bagian `redirect`. Logika ini bertugas sebagai satpam aplikasi:
- Jika user belum login/inisialisasi (`AuthInitial`, `AuthLoading`), diarahkan ke `/splash`.
- Jika user belum terotentikasi, diizinkan ke halaman login/register (`/landing`, `/login`, `/register`).
- Jika user sudah login, aplikasi akan mengecek peran (role) dari user:
  - Jika belum memiliki role, diarahkan ke `/select-role`.
  - Jika sudah memiliki role (misal `mother`), dan mencoba mengakses halaman auth/splash, mereka akan diarahkan langsung ke halaman `home` yang sesuai (misal: `/home-mother`).

### 2. Bottom Navigation Bar (`StatefulShellRoute`)

Aplikasi kita kini menggunakan **Bottom Navigation Bar** untuk setiap *role* (Mother, Caregiver, Doctor). Hal ini diimplementasikan menggunakan `StatefulShellRoute.indexedStack`. 
- Setiap tab (Home, Profile) diwakili oleh sebuah `StatefulShellBranch`.
- Rute-rute fitur turunan (seperti Growth, Development) harus diletakkan **di dalam properti `routes` milik branch tersebut**. Hal ini disebut **Nested Routing**.

### 3. Mendefinisikan Rute Baru

Saat ada halaman baru yang merupakan turunan dari suatu fitur (misal halaman detail dari Home), pastikan untuk meletakkannya di dalam properti `routes` (Nested Route) agar tombol *Back* pada *AppBar* tetap berfungsi dengan baik di dalam *Bottom Navigation Tab*.

**Contoh Struktur Nested Route:**
```dart
GoRoute(
  path: '/home-mother',
  name: AppRoutes.homeMother.name,
  builder: (context, state) => const HomeMotherPage(),
  routes: [ // Rute turunan (Nested)
    GoRoute(
      path: 'growth',
      name: AppRoutes.growth.name,
      builder: (context, state) => const GrowthPage(),
    ),
  ],
),
```

### 4. Parameter Ekstra (Route Args)

Jika halaman membutuhkan parameter kompleks (misal objek dari model atau multiple variables), buat class khusus di **`lib/core/routes/route_args.dart`**, misalnya `KpspAssessmentExtra`. **Dilarang meletakkan class argumen di dalam `router.dart`.**

```dart
// Di dalam lib/core/routes/route_args.dart
class KpspAssessmentExtra {
  final String childName;
  final String childAge;

  const KpspAssessmentExtra({required this.childName, required this.childAge});
}
```

## Cara Menggunakan (Navigasi)

Pastikan selalu import `go_router` pada file tempat Anda ingin melakukan navigasi:
```dart
import 'package:go_router/go_router.dart';
```

| Cara Lama (Navigator) | Cara Baru (GoRouter) | Penjelasan |
|---|---|---|
| `Navigator.push(...)` | `context.goNamed(AppRoutes.namaRute.name)` | Untuk pindah ke fitur di dalam *Nested Route* (Misal: Home → Growth). Tetap memunculkan tombol *Back*. |
| `Navigator.pushReplacement(...)` | `context.pushReplacementNamed(AppRoutes.namaRute.name)` | Berpindah halaman dan menghapus halaman saat ini dari history. Biasanya untuk hasil kuis. |
| `Navigator.pop(context)` | `context.pop()` | Kembali ke halaman sebelumnya. |
| `Navigator.popUntil(...)` | `context.goNamed(...)` | Pindah ke path tertentu secara absolut (bisa memecah hirarki jika tidak *nested*). |

> **PERHATIAN (pushNamed vs goNamed):** Karena kita menggunakan struktur *Nested Routing* di dalam `StatefulShellRoute`, **best practice untuk navigasi ke rute anak adalah menggunakan `context.goNamed()`**. GoRouter akan otomatis menyusun tumpukan (stack) sehingga tombol kembali di AppBar tetap ada. Gunakan `pushNamed` HANYA JIKA Anda ingin memaksakan sebuah layar baru ditaruh di atas layar saat ini yang berada di luar hierarki aslinya.

**Mengirim Parameter (Extra):**
```dart
context.goNamed(
  AppRoutes.developmentKpsp.name,
  extra: KpspAssessmentExtra(
    childName: 'Budi',
    childAge: '24 Bulan',
  ),
);
```

## Saat Menambah Halaman Baru
1. Buat class Page-nya.
2. Buka `lib/core/routes/route_args.dart` jika halaman tersebut butuh parameter ekstra, lalu tambahkan class `NamaHalamanExtra`.
3. Buka `lib/router.dart`.
4. Tambahkan rute baru ke dalam enum `AppRoutes`.
5. Tambahkan `GoRoute` baru di list `routes` yang tepat. **Penting:** Jika halaman tersebut adalah anak dari Home, masukkan ke dalam `routes:` milik `/home-mother` agar navigasi *Bottom Bar* tetap aktif.
6. Gunakan `context.goNamed(AppRoutes.namaRute.name)` di UI untuk menavigasikannya.
