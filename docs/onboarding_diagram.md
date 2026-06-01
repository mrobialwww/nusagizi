# Alur Onboarding (Pemilihan Role) - Nuzagizi

Berikut adalah diagram sekuensial (Sequence Diagram) yang memvisualisasikan bagaimana proses pemilihan *role* berjalan dari aplikasi Flutter, ke server Golang, hingga ke sistem keamanan Auth0.

```mermaid
sequenceDiagram
    autonumber
    
    actor User
    participant Flutter as Aplikasi Flutter (Client)
    participant Golang as Backend Golang (API)
    participant DB as Database Lokal (SQL)
    participant Auth0 as Auth0 Management API

    %% Langkah 1: Input Data
    User->>Flutter: Mengisi Form (Role, Gender, Age)
    Flutter->>Flutter: Validasi Form Lokal
    
    %% Langkah 2: Mengirim Request
    Note over Flutter, Golang: Mengirim data dengan Access Token LAMA (tanpa role)
    Flutter->>Golang: POST /api/v1/onboarding (Bearer Token Lama)
    
    %% Middleware & Ekstraksi Data
    Golang->>Golang: Validasi JWT & Ekstrak Auth0 ID (Sub)
    
    %% Langkah 3: Simpan DB
    Golang->>DB: UPDATE users SET role=..., gender=..., age=... WHERE auth0_id=Sub
    
    alt Gagal Update DB
        DB-->>Golang: Error
        Golang-->>Flutter: HTTP 500 (Gagal menyimpan data)
    else Sukses Update DB
        DB-->>Golang: Success
        
        %% Langkah 4: Tembak Auth0 Management API
        Note over Golang, Auth0: Proses Assign Role di Sistem Auth0
        Golang->>Auth0: Request M2M Access Token
        Auth0-->>Golang: Return M2M Token
        Golang->>Auth0: POST /api/v2/users/{sub}/roles (Masukkan Role ID)
        
        alt Gagal Assign Role Auth0
            Auth0-->>Golang: Error
            Note over Golang, DB: Mekanisme Rollback agar DB sinkron
            Golang->>DB: ROLLBACK (UPDATE users SET role=NULL ... WHERE auth0_id=Sub)
            Golang-->>Flutter: HTTP 502 (Gagal mendaftarkan role, coba lagi)
        else Sukses Assign Role Auth0
            Auth0-->>Golang: 204 No Content (Sukses)
            
            %% Langkah 5: Balasan Sukses
            Golang-->>Flutter: HTTP 200 OK (Onboarding berhasil)
            
            %% Langkah 6: Refresh Token & Navigasi
            Note over Flutter: Konfirmasi didapat, paksa Auth0 refresh token
            Flutter->>Auth0: Request Refresh Token (minTtl: 999999)
            
            Note over Auth0: Post-Login Action Auth0 otomatis berjalan<br/>Role di-inject ke dalam JWT baru
            Auth0-->>Flutter: Return Access Token BARU (berisi Custom Claim Role)
            
            Flutter->>Flutter: Decode JWT Baru & Baca Role
            Flutter->>User: Navigasi ke HomePage sesuai Role
        end
    end
```

### Keterangan Tambahan:
1. **Mekanisme Rollback**: Diagram di atas mengilustrasikan mengapa _rollback_ database penting. Jika Auth0 gagal merespons atau memproses, aplikasi mencegah _database_ lokal memiliki *role* sementara sistem autentikasi Auth0 tidak memilikinya.
2. **Post-Login Action**: Proses injeksi role ke dalam JWT tidak terjadi di Golang, melainkan terjadi secara otomatis di sistem Auth0 saat Flutter meminta penyegaran *(refresh)* token di langkah terakhir.
