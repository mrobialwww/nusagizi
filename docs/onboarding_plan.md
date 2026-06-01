# Rancangan Alur Onboarding — Nuzagizi

> Arsitektur: Flutter → Golang → Auth0 Management API → JWT Refresh → Navigasi

---

## Diagram Alur Keseluruhan

```
Flutter (OnboardingPage)
  │
  │  LANGKAH 1: User isi form
  │  { role: "mother", gender: "female", age: 28 }
  │
  ▼
POST /api/v1/onboarding
  │  Header: Authorization: Bearer <JWT Token lama (tanpa role)>
  │  Body:   { "role": "mother", "gender": "female", "age": 28 }
  │
  ▼
Golang — GinMiddleware (auth.middleware.go)
  │  - Validasi JWT Token
  │  - GetUserBySub → ambil data user dari DB
  │  - Set user ke context
  │
  ▼
Golang — OnboardingHandler (handlers/onboarding_handler.go)
  │
  │  LANGKAH 3: Simpan ke DB
  │  UPDATE users SET role=..., gender=..., age=... WHERE auth0_id=...
  │
  │  LANGKAH 4: Tembak Auth0 Management API
  │  POST https://{domain}/api/v2/users/{sub}/roles
  │  Body: { "roles": ["rol_KNrHXXr19QH2BWxn"] }  ← role ID dari .env
  │
  │  LANGKAH 5: Balas ke Flutter
  ▼
Response 200 OK
  { "message": "Onboarding berhasil!" }
  │
  ▼
Flutter — Terima 200 OK
  │
  │  LANGKAH 6: Paksa Refresh JWT
  │  auth0.credentialsManager.credentials(minTtl: 999999)
  │
  │  Auth0 Post-Login Action otomatis berjalan saat refresh:
  │  → Inject claim roles ke JWT baru
  │  → JWT baru sekarang punya: "https://api.nusagizi.com/roles": ["mother"]
  │
  │  Flutter decode JWT baru → baca role
  │
  ▼
Navigate ke HomePage (sesuai role)
```

---

## Detail Per Langkah

### Langkah 1 — Flutter Kumpulkan Data Form
**File:** `lib/features/onboarding/presentation/pages/onboarding_page.dart`

```
Input yang dikumpulkan:
- role   : String  → "mother" | "caregiver" | "doctor"
- gender : String  → "male" | "female"
- age    : int     → angka usia

Validasi di sisi Flutter:
- Semua field wajib diisi sebelum tombol Submit aktif
```

---

### Langkah 2 — Flutter Tembak Endpoint
**File:** `lib/features/onboarding/data/datasources/onboarding_remote_datasource.dart`

```
Method : POST
URL    : {baseUrl}/api/v1/onboarding
Header : Authorization: Bearer <access_token dari auth0.credentialsManager>
         Content-Type: application/json

Body JSON:
{
  "role":   "mother",
  "gender": "female",
  "age":    28
}
```

> ⚠️ Token yang dikirim di sini adalah token **lama** (belum ada claim role-nya).
> Ini normal karena Golang hanya butuh token ini untuk tahu siapa user-nya (via Sub).

---

### Langkah 3 — Golang Simpan ke DB
**File:** `internal/handlers/onboarding_handler.go`
**Memanggil:** `internal/repository/user_repository.go` → `UpdateUserOnboarding()`

```
Query yang dijalankan:
UPDATE users
SET role = $1, gender = $2, age = $3
WHERE auth0_id = $4

Parameter:
$1 = "mother"
$2 = "female"
$3 = 28
$4 = "auth0|xxxxxxxx"  ← diambil dari JWT claim Subject (Sub)
     yang sudah di-set middleware ke context: c.Get("user")
```

**Jika UPDATE gagal** → Return HTTP 500, jangan lanjut ke langkah 4.

---

### Langkah 4 — Golang Tembak Auth0 Management API
**File:** `internal/auth0/management.go` *(file baru)*

```
Alur fungsi AssignRoleToUser():

Step A — Dapatkan M2M Access Token (auto-generate, jangan hardcode!)
  POST https://{AUTH0_DOMAIN}/oauth/token
  Body: {
    "grant_type":    "client_credentials",
    "client_id":     CLIENT_ID dari .env,
    "client_secret": CLIENT_SECRET dari .env,
    "audience":      "https://{AUTH0_DOMAIN}/api/v2/"
  }
  → Simpan token ini di memori (bisa di-cache)

Step B — Tentukan Role ID dari .env berdasarkan role yang dipilih user
  "mother"    → AUTH0_ROLE_ID_MOTHER   = "rol_KNrHXXr19QH2BWxn"
  "caregiver" → AUTH0_ROLE_ID_CAREGIVER = "rol_QgyiCgSmpFaingGF"
  "doctor"    → AUTH0_ROLE_ID_DOCTOR    = "rol_RERBixCC7oBAcYwr"

Step C — Assign role ke user
  POST https://{AUTH0_DOMAIN}/api/v2/users/{auth0_sub}/roles
  Header: Authorization: Bearer <M2M Token dari Step A>
          Content-Type: application/json
  Body: {
    "roles": ["rol_KNrHXXr19QH2BWxn"]
  }
  → Jika status 204 No Content = sukses
```

> ⚠️ **Penting:** `ACCESS_TOKEN` yang ada di `.env` sekarang akan expired.
> Fungsi ini HARUS auto-generate token baru via `CLIENT_ID` + `CLIENT_SECRET`.

**Jika Assign Role gagal** → **ROLLBACK** UPDATE di DB, lalu return HTTP 502 ke Flutter

```
Alur Rollback:
1. Langkah 3 (UPDATE DB) berhasil
2. Langkah 4 (Auth0 API) GAGAL
3. Jalankan query kebalikannya:
   UPDATE users SET role = NULL, gender = NULL, age = NULL
   WHERE auth0_id = $1
4. Return HTTP 502 ke Flutter:
   { "error": "Gagal mendaftarkan role, silakan coba lagi" }
```

> Dengan rollback ini, DB dan Auth0 selalu dalam kondisi sinkron.
> User bisa mengulang proses onboarding dari awal tanpa data tersisa di DB.

---

### Langkah 5 — Golang Balas ke Flutter
**File:** `internal/handlers/onboarding_handler.go`

```
Jika langkah 3 dan 4 berhasil:
HTTP 200 OK
{
  "message": "Onboarding berhasil!",
  "role":    "mother"
}

Jika langkah 3 gagal (DB error):
HTTP 500 Internal Server Error
{ "error": "Gagal menyimpan data onboarding" }

Jika langkah 4 gagal (Auth0 error):
→ Golang rollback UPDATE di DB terlebih dahulu
→ Kemudian balas:
HTTP 502 Bad Gateway
{ "error": "Gagal mendaftarkan role, silakan coba lagi" }

→ Di Flutter, jika dapat 502, tampilkan snackbar error.
   User bisa tekan tombol Submit lagi (safe karena DB sudah di-rollback).
```

---

### Langkah 6 — Flutter Refresh JWT & Navigasi
**File:** `lib/features/onboarding/presentation/cubit/onboarding_cubit.dart`

```
Setelah menerima response 200 OK dari Golang:

Step A — Paksa Refresh Token
  credentials = await auth0.credentialsManager.credentials(
    minTtl: 999999  // Paksa refresh karena token yang ada pasti belum punya role
  )
  // minTtl: 999999 artinya "token harus masih valid setidaknya 999999 detik"
  // karena token baru saja didapat (berlaku ~86400 detik), kondisi ini
  // tidak akan pernah terpenuhi, sehingga Auth0 PASTI akan refresh token-nya.
  
  → Auth0 Post-Login Action otomatis berjalan saat token di-generate ulang
  → JWT baru akan punya claim:
    "https://api.nusagizi.com/roles": ["mother"]

Step B — Decode role dari accessToken secara manual
  // JWT terdiri dari 3 bagian: header.payload.signature
  // Kita hanya perlu bagian payload (index ke-1)

  String decodeRolesFromToken(String accessToken) {
    final parts = accessToken.split('.');
    // Tambah padding Base64 jika perlu
    String payload = parts[1];
    final remainder = payload.length % 4;
    if (remainder != 0) payload += '=' * (4 - remainder);

    // Decode Base64 → JSON String → Map
    final decoded = utf8.decode(base64Url.decode(payload));
    final Map<String, dynamic> claims = jsonDecode(decoded);

    // Ambil custom claim yang diset Auth0 Post-Login Action
    final roles = claims['https://api.nuzagizi.com/roles'] as List?;
    return roles?.first ?? '';
  }

Step C — Navigasi berdasarkan role
  switch (roles.first) {
    "mother"    → Navigator.pushReplacementNamed('/home/mother')
    "caregiver" → Navigator.pushReplacementNamed('/home/caregiver')
    "doctor"    → Navigator.pushReplacementNamed('/home/doctor')
  }
```

---

## File-File yang Perlu Dibuat/Diubah

### Backend (Golang)

| Status | File | Perubahan |
|--------|------|-----------|
| 🔧 Edit | `internal/models/user.go` | Tambah field `Role`, `Gender`, `Age` |
| 🔧 Edit | `internal/config/config.go` | Tambah `ClientID`, `ClientSecret`, `RoleID*` |
| 🔧 Edit | `internal/repository/user_repository.go` | Tambah fungsi `UpdateUserOnboarding()` |
| 🆕 Buat | `internal/auth0/management.go` | Fungsi `AssignRoleToUser()` |
| 🆕 Buat | `internal/handlers/onboarding_handler.go` | Handler utama |
| 🔧 Edit | `cmd/api/main.go` | Daftarkan route `POST /api/v1/onboarding` |

### Frontend (Flutter)

| Status | File | Perubahan |
|--------|------|-----------|
| 🆕 Buat | `features/onboarding/domain/entities/onboarding_entity.dart` | Entity |
| 🆕 Buat | `features/onboarding/data/datasources/onboarding_remote_datasource.dart` | Panggil API |
| 🆕 Buat | `features/onboarding/data/repositories/onboarding_repository_impl.dart` | Implementasi |
| 🆕 Buat | `features/onboarding/domain/repositories/onboarding_repository.dart` | Abstract |
| 🆕 Buat | `features/onboarding/domain/usecases/submit_onboarding.dart` | Use case |
| 🆕 Buat | `features/onboarding/presentation/cubit/onboarding_cubit.dart` | State management |
| 🆕 Buat | `features/onboarding/presentation/pages/onboarding_page.dart` | UI Form |
| 🆕 Buat | `features/onboarding/data/models/onboarding_model.dart` | Request model |  
| 🔧 Edit | `features/splash/presentation/pages/splash_screen.dart` | Cek role di JWT (decode accessToken) |

---

## Urutan Pengerjaan yang Disarankan

```
1. Jalankan SQL: ALTER TABLE users ADD COLUMN role, gender, age
2. Edit  → models/user.go
3. Edit  → config/config.go  
4. Edit  → repository/user_repository.go  (tambah UpdateUserOnboarding)
5. Buat  → internal/auth0/management.go
6. Buat  → handlers/onboarding_handler.go
7. Edit  → cmd/api/main.go (daftarkan route)
8. Test  → Postman/Thunder Client
─────────────────────────────────────
9. Buat  → Semua layer onboarding di Flutter
10. Edit → Splash Screen Flutter (logika cek role)
11. Test → End-to-end di emulator/device
```
