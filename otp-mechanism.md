# Rangkuman: Mekanisme Kirim OTP Registrasi (Flutter + Auth0 + Gin)

**Tanggal:** 6 Agustus 2026
**Tech stack:** Flutter (Android) + `auth0_flutter` + Golang (Gin)

---

## 1. Requirement Awal

- OTP dikirim lewat **email saja**.
- Backend Gin **tidak dipakai sama sekali** selama user belum terbentuk di Auth0 — proses register/login murni Flutter ↔ Auth0. Gin baru berperan verifikasi JWT setelah user ada.
- OTP untuk kebutuhan **registrasi saja**.
- Model login: **Embedded/Native** (custom UI, pakai Authentication API client `auth0.api`, bukan Universal Login/WebView).
- Target platform: **Android** saja untuk saat ini.

## 2. Iterasi 1 — Passwordless Email OTP (tanpa password)

Desain awal pakai **Auth0 Passwordless (Email OTP)**:

1. `auth0.api.startPasswordlessWithEmail(email, PasswordlessType.code)` → kirim OTP.
2. `auth0.api.loginWithEmailCode(email, verificationCode)` → verifikasi, user baru otomatis terbentuk di Auth0 saat kode pertama kali benar.

**Setup Auth0 Dashboard yang diperlukan:**
- Authentication → Passwordless → aktifkan **Email**.
- Pastikan **Disable Sign Ups** tidak dicentang (supaya user baru otomatis terbentuk).
- Applications → [App Native] → Advanced Settings → Grant Types → aktifkan **Passwordless OTP**.

**Fakta penting dari dokumentasi resmi Auth0:**
- Kode OTP default valid **3 menit**, hanya kode terakhir yang berlaku, maksimal 3 kali salah input sebelum harus minta kode baru.
- User baru **baru benar-benar terbentuk saat OTP berhasil diverifikasi**, bukan saat OTP dikirim — jadi tidak ada akun "nyangkut" kalau user batal di tengah jalan.

## 3. Diskusi: Perilaku App saat User Belum Verifikasi OTP

**Skenario dibahas:** user keluar app sebelum verifikasi OTP, lalu masuk lagi — baik app masih di background maupun di-kill (sengaja/tidak sengaja oleh OS).

**Kesimpulan (dengan implementasi Iterasi 1, tanpa persistence):**
- **App masih di background:** layar OTP & state (email yang diketik) tetap ada karena Dart isolate & Navigator stack masih hidup. Risiko: timer cooldown resend bisa tidak akurat, dan kalau OTP sudah lewat 3 menit, kodenya sudah expired walau layar masih tampil sama.
- **App di-kill:** seluruh state hilang, app restart dari layar awal, user harus mulai dari input email lagi dan minta OTP baru. Ini **tidak berbahaya** secara data (karena user Auth0 belum terbentuk kalau OTP belum diverifikasi), hanya kurang nyaman dari sisi UX.
- **Perbaikan opsional yang diusulkan** (belum diimplementasikan): simpan `email` pending + timestamp via `shared_preferences`, supaya app-kill tidak memaksa user mengulang dari nol selama masih dalam window OTP. **Item ini masih open / belum dikerjakan** — bisa dilanjutkan di sesi berikutnya kalau dibutuhkan.

## 4. Perubahan Requirement — Pindah ke Email + Password

User memutuskan form registrasi butuh **email + password sekaligus**, dengan OTP berperan sebagai **verifikasi kepemilikan email** setelah signup (akun dianggap aktif setelah OTP benar) — bukan lagi passwordless login.

## 5. Konflik Arsitektur yang Ditemukan

Auth0 punya fitur bawaan "OTP saat signup untuk verifikasi email", tapi menurut dokumentasi resmi:

> Untuk memakai fitur OTP verifikasi email ini, tenant wajib mengaktifkan **Universal Login**, **Flexible Identifiers**, dan **Identifier-First login**.

Artinya fitur bawaan ini **hanya jalan lewat halaman hosted Auth0 (Universal Login)**, bukan lewat Authentication API client (`auth0.api`) yang dipakai untuk custom UI embedded. Ini berbenturan dengan 3 requirement sekaligus:

1. Custom UI 100% embedded (tanpa buka halaman Auth0)
2. Email+password dengan status aktif baru setelah OTP benar
3. Tidak ada Gin/backend sama sekali di tahap registrasi

Karena menandai `email_verified = true` secara aman **butuh Management API** (kredensial server-side, tidak boleh ada di app Flutter), salah satu requirement harus disesuaikan.

**3 opsi yang didiskusikan:**

| Opsi | Deskripsi | Trade-off |
|---|---|---|
| 1 | Pindah ke Universal Login untuk proses signup | Auth0 urus semuanya otomatis, tapi UI jadi halaman hosted Auth0, bukan custom form native |
| **2 (dipilih)** | Tetap custom UI embedded + 1 endpoint Gin minimal | 1 endpoint tambahan di Gin, tapi 1 identitas per user, `email_verified` valid & bisa ditegakkan |
| 3 | Tetap custom UI, tanpa Gin sama sekali | Berujung 2 identitas terpisah per user (password vs passwordless), atau OTP jadi "security theater" yang tidak benar-benar mengunci apa pun |

**Keputusan: Opsi 2.**

## 6. Arsitektur Final (Opsi 2)

```
[Flutter] Isi Email + Password
     │
     ▼
auth0.api.signup(email, password, "Username-Password-Authentication")
     │  → User database terbentuk, email_verified: false
     ▼
auth0.api.startPasswordlessWithEmail(email, code)
     │  → OTP dikirim ke email
     ▼
[Flutter] Isi kode OTP
     │
     ▼
auth0.api.loginWithEmailCode(email, code)
     │  → Dapat ID Token (bukti kepemilikan email, dari connection
     │     Passwordless "email" -- identitas terpisah dari user database)
     ▼
POST /internal/confirm-email  (SATU-SATUNYA panggilan ke Gin)
     │  → Gin verifikasi signature ID Token via JWKS Auth0
     │  → Gin cek email_verified di token = true
     │  → Gin cari user DATABASE dengan email yang sama via
     │     Management API (users-by-email, filter connection
     │     Username-Password-Authentication)
     │  → Gin PATCH email_verified=true ke user database itu
     ▼
auth0.api.login(email, password, "Username-Password-Authentication")
     │  → Login definitif, INI sesi utama user
     ▼
Credentials disimpan via CredentialsManager → Registrasi selesai
```

**Poin penting:** ID Token dari langkah verifikasi OTP dan user database (email+password) adalah **dua identitas Auth0 yang berbeda** meski emailnya sama (beda connection). Endpoint Gin men-jembatani keduanya lewat pencarian by-email di Management API — bukan lewat account linking otomatis Auth0.

**Peran Gin ditegaskan ulang:** endpoint `/internal/confirm-email` **bukan** middleware verifikasi JWT session/protected resource biasa. Ini cuma jembatan sekali pakai ke Management API (yang butuh client secret, sehingga tidak boleh dipanggil langsung dari app). Verifikasi JWT untuk resource lain tetap di luar scope tahap registrasi ini, sesuai requirement awal.

## 7. File yang Dibuat

### Flutter (`flutter_app/lib/`)
| File | Isi |
|---|---|
| `core/auth/auth0_config.dart` | Domain, client ID Auth0, base URL backend |
| `core/auth/otp_auth_service.dart` | 5 method: `registerWithEmailPassword`, `sendEmailVerificationOtp`, `verifyEmailOwnership`, `confirmEmailWithBackend`, `loginWithPassword` |
| `features/auth/register_screen.dart` | Form Email + Password + Konfirmasi Password |
| `features/auth/register_otp_screen.dart` | Input OTP → konfirmasi ke Gin → login final, dengan resend cooldown 30 detik & error mapping |

### Backend Gin (`gin_backend/`)
| File | Isi |
|---|---|
| `internal/config/config.go` | Baca env var (domain, native client ID, kredensial M2M) |
| `internal/auth0client/jwks_verifier.go` | Validasi ID Token (signature RS256 via JWKS, issuer, audience, expiry) |
| `internal/auth0client/management_client.go` | Ambil token M2M, cari user database by email, PATCH `email_verified` |
| `internal/handler/confirm_email_handler.go` | Handler `POST /internal/confirm-email` |
| `cmd/server/main.go` | Contoh wiring endpoint ke router Gin |
| `go.mod` | Dependency: `gin-gonic/gin`, `golang-jwt/jwt/v5`, `MicahParks/keyfunc/v3` |

## 8. Setup yang Wajib Dilakukan di Auth0 Dashboard

1. **Authentication → Passwordless** → aktifkan **Email** (untuk kirim OTP verifikasi).
2. **Applications → [App Native] → Advanced Settings → Grant Types** → aktifkan **Passwordless OTP** DAN **Password** (aktifkan juga `password-realm`).
3. Buat **Auth0 Application baru bertipe Machine to Machine**, authorize ke **Auth0 Management API** dengan scope `read:users` dan `update:users`. Simpan client ID & secret ini **hanya di server**, isi ke env var `AUTH0_M2M_CLIENT_ID` / `AUTH0_M2M_CLIENT_SECRET`.
4. Set env var backend: `AUTH0_DOMAIN`, `AUTH0_NATIVE_CLIENT_ID` (client ID App Native Flutter, untuk validasi audience ID Token).
5. *(Opsional, disarankan)* Nonaktifkan/kustomisasi email verifikasi bawaan Auth0 (magic link) di connection database, supaya user tidak dapat 2 email berbeda (satu magic link default, satu OTP custom kita).

## 9. Item yang Masih Terbuka (Belum Dikerjakan)

- **Persistence pending-registration** saat app di-kill sebelum OTP diverifikasi (dibahas di Bagian 3, opsi pakai `shared_preferences`) — belum diimplementasikan, tunggu konfirmasi lanjut.
- Penanganan **Bot Detection** Auth0 (`isVerificationRequired`) belum ditambahkan — perlu info apakah fitur ini aktif di tenant.
- `go.mod` dibuat manual (belum sempat `go mod tidy` karena sandbox tidak punya akses ke proxy Go module) — jalankan `go mod tidy` setelah file dipindah ke repo asli.
- Module path `yourapp/backend` di kode Go adalah placeholder — sesuaikan dengan module path project Gin yang sudah ada.

## 10. Link Dokumentasi Resmi

- Passwordless Login — auth0_flutter (contoh kode `startPasswordlessWithEmail` & `loginWithEmailCode`): https://github.com/auth0/auth0-flutter/blob/main/auth0_flutter/EXAMPLES.md#passwordless-login
- Referensi class `AuthenticationApi` (auth0_flutter): https://pub.dev/documentation/auth0_flutter/latest/auth0_flutter/AuthenticationApi-class.html
- Referensi `ApiException`: https://pub.dev/documentation/auth0_flutter_platform_interface/latest/auth0_flutter_platform_interface/ApiException-class.html
- Passwordless Authentication with Email: https://auth0.com/docs/authenticate/passwordless/authentication-methods/email-otp
- Embedded Passwordless Login di aplikasi Native: https://auth0.com/docs/authenticate/passwordless/implement-login/embedded-login/native
- Verify Emails using Auth0 (termasuk penjelasan OTP + syarat Universal Login/Identifier-First): https://auth0.com/docs/manage-users/user-accounts/verify-emails
- Update Grant Types (mengaktifkan Password & Passwordless OTP grant): https://auth0.com/docs/get-started/applications/update-grant-types
- Auth0 Management API — Update a User: https://auth0.com/docs/api/management/v2#!/Users/patch_users_by_id
- Auth0 Management API — Get Users by Email: https://auth0.com/docs/api/management/v2#!/Users_By_Email/get_users_by_email
- `golang-jwt/jwt/v5`: https://github.com/golang-jwt/jwt
- `MicahParks/keyfunc/v3` (JWKS client untuk golang-jwt v5): https://github.com/MicahParks/keyfunc
