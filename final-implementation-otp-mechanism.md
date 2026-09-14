# Alur Lengkap Registrasi & Verifikasi OTP (Auth0 + Gin)

Dokumen ini menjelaskan alur lengkap mekanisme OTP 5-Langkah dari antarmuka pengguna (UI) hingga eksekusi di backend (Data Layer), serta bagaimana *router* menanganinya. Alur ini sudah diperbarui sesuai arsitektur terbaru (penggabungan `AuthService`, penghapusan `Equatable`, dan perampingan Exception).

---

## Fase 1: Inisiasi Registrasi (Membuat Akun & Mengirim OTP)

**1. Presentation Layer (`RegisterPage`)**
- User mengisi **Username, Email, dan Password**.
- User menekan tombol "Daftar".
- UI memanggil `context.read<AuthCubit>().startRegistration(username, email, password)`.
- Cubit meng-emit state `AuthLoading` (tombol berubah jadi indikator loading).

**2. Domain Layer (`StartRegistrationUseCase`)**
- `StartRegistrationUseCase` menerima objek parameter `StartRegistrationParams` (berisi DTO murni tanpa `Equatable`).
- Use Case meneruskan objek tersebut ke kontrak abstrak `AuthRepository.startRegistration`.

**3. Data Layer (`AuthRepositoryImpl` & `AuthService`)**
- Repository menjalankan **Langkah 1**: Memanggil `service.register(email, password, username)`. Ini mendaftarkan user di database Auth0 (koneksi `Username-Password-Authentication`). Akun tercipta, namun status `email_verified` masih `false`.
- Repository menjalankan **Langkah 2**: Memanggil `service.sendEmailVerificationOtp(email)`. Ini memicu fitur Passwordless Auth0 untuk mengirimkan 6-digit kode OTP ke email user.

**4. Kembali ke Presentation & Router**
- Jika sukses, `AuthRepositoryImpl` mengembalikan `Right(null)`.
- `AuthCubit` meng-emit state baru: `AuthOtpPending(email, password)`.
- **Router (`router.dart`)**: Mendeteksi perubahan state ke `AuthOtpPending`. GoRouter dikonfigurasi untuk mengembalikan `null` (artinya: "izinkan user tetap di halaman saat ini, jangan *force redirect* ke landing page").
- `BlocConsumer` di `RegisterPage` bereaksi terhadap `AuthOtpPending` dengan melakukan navigasi ke rute *top-level* OTP: 
  `context.goNamed('/otp', extra: {'email': ..., 'password': ...})`.
- **(Penting)**: Password hanya dikirimkan antar-halaman di dalam memori internal (via parameter `extra` GoRouter), tidak pernah dicetak (print) atau ditulis ke penyimpanan fisik (disk).

---

## Fase 2: Verifikasi OTP & Login Final

**1. Presentation Layer (`RegisterOtpScreen`)**
- User diarahkan ke URL `/otp` (dikelola sebagai *top-level route*) dan melihat alamat emailnya di layar.
- User memasukkan 6-digit OTP dari email dan menekan "Verifikasi".
- UI memanggil `context.read<AuthCubit>().verifyOtpAndLogin(email, otpCode, password)`.
- Cubit kembali meng-emit state `AuthLoading`.

**2. Domain Layer (`VerifyOtpAndLoginUseCase`)**
- `VerifyOtpAndLoginUseCase` meneruskan objek `VerifyOtpParams` (DTO tanpa `Equatable`) ke `AuthRepository.verifyOtpAndLogin`.

**3. Data Layer (`AuthRepositoryImpl` & `AuthService`)**
- Repository menjalankan **Langkah 3**: Memanggil `service.verifyEmailOwnership(email, otpCode)`. Auth0 memverifikasi kode OTP. Jika benar, Auth0 mengembalikan `Credentials` (yang berisi `id_token` sebagai bukti otentik).
- Repository menjalankan **Langkah 4**: Memanggil `service.confirmEmailWithBackend(idToken)`. Aplikasi menembak API backend Golang (Gin) di endpoint `/internal/confirm-email` menggunakan **Dio**.
  - Jika gagal, metode ini sekarang cukup melemparkan standar bawaan Dart `Exception('Failed to confirm email: ...')` (tanpa *overengineering* custom exception).
  - *Di sisi Backend (Golang)*: Gin memvalidasi `id_token` tersebut, mengambil emailnya, lalu memanggil Auth0 Management API untuk mengubah status `email_verified = true` untuk akun user tersebut.
- Repository menjalankan **Langkah 5**: Memanggil `service.login(email, password)`. Karena akun kini sudah terverifikasi di backend, user otomatis diizinkan untuk login secara penuh menggunakan kredensial utamanya.
- JWT Session Token disimpan di device oleh `AuthService` dan objek `UserEntity` di-return kembali.

**4. Kembali ke Presentation & Router**
- `AuthCubit` meng-emit state `AuthAuthenticated(user)`.
- **Router (`router.dart`)**: GoRouter mendeteksi perubahan state ke `AuthAuthenticated`. Router akan mengecek data *role* di dalam token JWT user. Karena ini adalah registrasi baru, *role* masih kosong.
- Router melakukan *force redirect* ke halaman pemilihan *role*: `return '/select-role'`.
- Layar OTP otomatis tertutup dan user sekarang berada di halaman **Select Role**.

---

### Mengapa Desain Akhir Ini Sangat Baik?

1. **Pemisahan Tanggung Jawab & Bersih (*Clean*)**: Halaman UI (`RegisterOtpScreen`) sama sekali tidak tahu tentang HTTP, Dio, Auth0, atau Gin. UI murni hanya berbicara dengan `AuthCubit`. Use case-nya pun murni tanpa dependensi library eksternal (seperti Equatable).
2. **Tanpa Duplikasi dan *Overengineering***: 3 fungsi OTP terpusat dengan rapi ke dalam `AuthService` (bukan service terpisah), penanganan exception menggunakan `Exception` bawaan Dart, serta Langkah 1 dan Langkah 5 otomatis me-reuse kode registrasi/login yang sudah ada.
3. **Keamanan Ekstra**: Endpoint Gin tidak menggunakan *Bearer token* pengguna (karena sesi login belum tercipta). Ia hanya membutuhkan `id_token` hasil verifikasi OTP, sehingga request ini dapat dieksekusi dengan aman tanpa menyentuh *Interceptor Auth* dari *Dio*.
