# Nusagizi

Nusagizi adalah ekosistem aplikasi perintis yang memadukan teknologi canggih untuk mengawal tumbuh kembang dan gizi anak secara komprehensif. Aplikasi ini secara cerdas menjembatani manajemen pengasuhan anak antara **Ibu** dan **Pengasuh** secara real-time.

---

## 🔑 Akun Demo (Untuk Akses Evaluasi)

Bagi penguji atau tim penilai yang ingin meninjau secara saksama setiap alur tanpa harus mendaftar ulang, silakan akses menggunakan kombinasi kredensial (Email & Kata Sandi) di bawah ini:

### 1. Mode Ibu (Mother Role)
- **Email:** `robialwan8@gmail.com`
- **Password:** `Robialwan123#`
- **Hak Akses:** Profil pimpinan ekosistem keluarga *(Super Role Flow)*. Dapat menambah sub-profil anak, melakukan *Generate AI Menu* harian, me-*review* dan menyetujui tangkapan foto baru kiriman Pengasuh, hingga membaca evaluasi matriks seluruh riwayat Tumbuh, Kembang, dan Gizi anak.

### 2. Mode Pengasuh (Caregiver Role)
- **Email:** `robialwan4@gmail.com`
- **Password:** `Robialwan123#`
- **Hak Akses:** Mode operasional fungsional & terfokus. Dapat melakukan *checklist* (centang porsi habis) makanan pendamping anak khusus untuk kalender hari berjalan, mengunggah foto anak berstatus *pending review*, serta menerbitkan pengajuan pemesanan kebutuhan (stok keranjang *groceries* habis).

---

## 🌟 Fitur Utama

Nusagizi dibangun di atas tiga pilar utama dan fitur pendukung, yaitu:

### 1. GIZI (Nutrisi Otomatis & AI Pintar)
Pemantauan target makronutrien (Karbohidrat, Protein, Lemak, dll) harian anak. 
Fitur sentral kami menggunakan **Rule-Based AI** yang secara cermat menentukan jadwal makanan:
- AI menilai rentang usia, data medis (alergi/kondisi khusus), dan bersandar pada referensi **kurva WHO** demi menyusun presisi kelayakan persentase target gizi.
- Setiap sesi hidangan diracik murni secara sekuensial (karbohidrat → protein → lemak → sayur → buah).
- Sistem memegang **Strict Allergy Filter**! Modul filtrasi alergi berjalan mutlak tanpa kelonggaran. 
- Jika ketersediaan satu komponen habis, AI melakukan *Cascade Fallback* pintar dari kategori turunannya.
- Bahan yang terpilih otomatis disortir ke *template* resep (dan marinasi untuk lauk), melahirkan bukan hanya perintah masak yang terperinci melainkan beserta 3 kandidat racikan alternatif bergizi serupa. 
- Sebagai finalisasi keselamatan dan keakuratan, mesin AI menjalankan pengecekan-ulang *(Re-Check)* atas seluruh potensi alergen sebelum pada akhirnya mendistribusikan hasil rekomendasi jadawal per 7-hari secara akurat.

### 2. TUMBUH (Growth Tracking)
Pemantauan indikator fisik anak secara berkala. Orang tua dapat menginput tinggi dan berat badan anak. Aplikasi akan menyajikannya ke dalam grafik rekam jejak kurva yang bergerak dinamis tiap bulannya, mendeteksi kesehatan bentuk fisik anak.

### 3. KEMBANG (Development & Asesmen KPSP)
Deteksi dini perkembangan kognitif dan motorik anak menggunakan indikator panduan KPSP (Kuesioner Praskrining Perkembangan). Dilengkapi dengan gambar interaktif serta skor evaluasi komprehensif di akhir pengisian.

### 4. Modul Sosial & Galeri Memori
Jurnal digital eksklusif untuk mendokumentasikan keseharian anak.
- **Kamera Terintegrasi:** Rekam kegiatan ceria anak langsung di dalam aplikasi, sisipkan *caption*, lalu pilih kontrol visibilitas (Privasi/Semua/Teman Terdekat).
- **Galeri Memori:** Akses cepat pintar (melalui kalender) yang seketika melompat ke halaman Galeri, merapikan linimasa kumpulan memori anak berdasarkan urutan bulan maupun tahun.

### 5. Akses Pengasuh & Belanja
Sinergi antara lingkungan kerja dan kewaspadaan rumah (melalui Scan QR Code Sinkronisasi Access).
- **Mode Pengasuh:** Tampilan lebih spesifik untuk memotret anak saat ibu tidak di tempat, merinci centang porsi masakan sarapan/makan siang anak, serta mengajukan stok belanja apabila bahan harian menipis.
- **Modul Belanja:** Melakukan konversi menu resep harian dari AI menjadi daftar keranjang belanja instan layaknya *personal shopper*.

---

## 🛠️ Tech Stack & Arsitektur

Nusagizi menggunakan arsitektur tiga lapis (Three-Tier Architecture) yang kokoh dan menjamin ketersediaan sistem:

1. **Client Layer (Flutter):**
   Mendukung UI *(User Interface)* yang konsisten, sangat mulus dan responsif di berbagai perangkat seluler. Pilihan *framework* Flutter memberikan fleksibilitas maksimal, memastikan perpindahan antara Mode Ibu dan Mode Pengasuh berjalan semulus sutra. Kami sepenuhnya menggunakan arsitektur struktural via manajemen *State BLoC/Cubit* dan *clean services locator*.
2. **Server / API Layer (Golang):**
   Dapur operasional sentral *micro-service* ditenagai oleh performa gahar bahasa Go. Melalui komputasi pararel yang tinggi (*High Concurrency*), **Go** dijamin mampu menggerakkan antrean data besar—seperti pengolahan algoritma AI yang ekstrem, transmisi foto Cloudflare R2 presigned, maupun enkripsi *User Identity*—tanpa hambatan dan latensi.
3. **Database Layer (PostgreSQL):**
   Mempercayakan keping-keping informasi sensitif gizi medis di atas entitas relasional (RDBMS) solid. Postgres ditugaskan memetakan relasi kompleks sirkulasi *(relationships)* keluarga Anda: mengunci integrasi mulus antara sinkronisasi Pengasuh dan hak akses Ibu, sembari menjaga akurasi relasional untuk riwayat nutrisi rekam jejak bulanannya agar terhubung secara instan dan tanpa celah keamanan.

---

## 🚀 Cara Menjalankan Project (Local Development) & Instalasi

### Prasyarat Instalasi
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi *stable* terbaru)
- Dart SDK
- IDE (VSCode / Android Studio)

### Cara Menjalankan Aplikasi
1. **Clone repositori aplikasi ini:**
   ```bash
   git clone https://github.com/mrobialwww/nusagizi.git
   ```
2. **Pindah ke direktori project:**
   ```bash
   cd nusagizi
   ```
3. **Unduh seluruh dependensi aplikasi:**
   ```bash
   flutter pub get
   ```
4. **Jalankan aplikasi ke dalam perangkat/emulator:**
   ```bash
   flutter run
   ```

*(Pastikan URL Endpoint backend pada file `.env` (atau setara) sudah dikonfigurasi mengarah ke server Golang Anda yang sedang aktif).*

---

## 🧪 Spesifikasi Lingkungan Pengujian (Testing Environment)

Aplikasi Nusagizi telah dirancang dan diuji pada lingkungan operasional berikut:
- **Sistem Target:** Android dan iOS
- **Perangkat Pengujian Utama:** *Real Device* & Emulator (Minimum SDK: Android 8.0 Oreo (API 26) / iOS 12.0)
- **Internet / Koneksi:** Memerlukan konektivitas yang stabil (Wi-Fi/LTE/4G), dikhususkan pada fitur perhitungan API (Rule-based AI) dan unggahan *cloud media* yang aktif (R2).
- **Aspek Resolusi:** Responsif sepenuhnya pada ragam ukuran rasio dan dimensi layar (termasuk *tablet/pad*) berkat implementasi kalkulasi `flutter_screenutil`.

---
