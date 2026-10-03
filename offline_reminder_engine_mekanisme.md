# offline_reminder_engine — Dokumentasi Mekanisme Lengkap

> Dokumen ini disusun dari pembacaan langsung seluruh source code repository
> `https://github.com/enilfrus24-tech/offline_reminder_engine` (commit terakhir `ddfb4d3`, 6 Maret 2026).
> Setiap klaim tentang perilaku kode merujuk ke file dan nomor baris. Bagian yang bergantung pada
> perilaku plugin pihak ketiga (`flutter_local_notifications`) atau sistem Android ditandai
> sebagai **catatan eksternal** dan sebaiknya diverifikasi terhadap dokumentasi resmi versi yang dipakai.

---

## Daftar Isi

1. [Ringkasan Singkat](#1-ringkasan-singkat)
2. [Struktur Repository](#2-struktur-repository)
3. [Dependensi dan Lingkungan](#3-dependensi-dan-lingkungan)
4. [Arsitektur dan Pembagian Tanggung Jawab](#4-arsitektur-dan-pembagian-tanggung-jawab)
5. [Model Data: `Reminder`](#5-model-data-reminder)
6. [Lapisan API: `ReminderManager`](#6-lapisan-api-remindermanager)
7. [Lapisan Platform: `NotificationService`](#7-lapisan-platform-notificationservice)
8. [Alur Kerja End-to-End](#8-alur-kerja-end-to-end)
9. [Mekanisme Penjadwalan Android](#9-mekanisme-penjadwalan-android)
10. [Mekanisme Zona Waktu](#10-mekanisme-zona-waktu)
11. [Mekanisme Pengulangan (Repeat)](#11-mekanisme-pengulangan-repeat)
12. [Mekanisme ID Notifikasi](#12-mekanisme-id-notifikasi)
13. [Channel dan Tampilan Notifikasi](#13-channel-dan-tampilan-notifikasi)
14. [Penanganan Waktu yang Sudah Lewat](#14-penanganan-waktu-yang-sudah-lewat)
15. [Yang Tidak Ada di Repository](#15-yang-tidak-ada-di-repository)
16. [Temuan, Risiko, dan Keterbatasan](#16-temuan-risiko-dan-keterbatasan)
17. [Checklist Integrasi ke Aplikasi](#17-checklist-integrasi-ke-aplikasi)
18. [Contoh Penggunaan Lengkap](#18-contoh-penggunaan-lengkap)
19. [Status Proyek, Roadmap, Riwayat Git, Lisensi](#19-status-proyek-roadmap-riwayat-git-lisensi)
20. [Peta Referensi File dan Baris](#20-peta-referensi-file-dan-baris)

---

## 1. Ringkasan Singkat

`offline_reminder_engine` adalah paket Flutter kecil (sekitar 187 baris Dart) yang membungkus
`flutter_local_notifications` agar pengingat bisa dijadwalkan secara offline dan tetap berbunyi
ketika aplikasi ditutup.

Inti mekanismenya hanya satu: **menyerahkan penjadwalan ke `AlarmManager` Android** melalui plugin,
dengan mode `AndroidScheduleMode.alarmClock`. Paket ini sendiri **tidak menjalankan proses di latar belakang**,
tidak memakai `Timer`, WorkManager, atau isolate. Setelah alarm terdaftar di sistem, Android yang
membangunkan notifikasi pada waktunya.

Paket terdiri dari tiga komponen:

| Komponen | Peran |
|---|---|
| `Reminder` | Model data pengingat (id, teks, waktu, status aktif, pola ulang) beserta serialisasi JSON |
| `ReminderManager` | Fasad statis: `initialize`, `schedule`, `cancel`, `rebuildAll` |
| `NotificationService` | Lapisan yang berbicara langsung ke plugin notifikasi dan `timezone` |

---

## 2. Struktur Repository

```
offline_reminder_engine/
├── .gitignore                                   # Template standar Flutter/Dart
├── CHANGELOG.md                                 # Masih template ("0.0.1 TODO")
├── LICENSE.txt                                  # MIT
├── README.md                                    # Deskripsi, fitur, roadmap, contoh dasar
├── Screenshot_20260305_081706_One UI Home.jpg   # Bukti demo (~1,2 MB), dipakai di README
├── pubspec.yaml                                 # Metadata paket + dependensi
└── lib/
    ├── offline_reminder_engine.dart             # Barrel file (3 export)
    └── src/
        ├── models/
        │   └── reminder.dart                    # Class Reminder
        └── services/
            ├── reminder_manager.dart            # Class ReminderManager
            └── notification_service.dart        # Class NotificationService
```

Tidak ada folder `android/`, `ios/`, `test/`, atau `example/`. Paket ini murni Dart.

**Barrel file** (`lib/offline_reminder_engine.dart`) mengekspor tiga hal ke pengguna paket:
`Reminder`, `ReminderManager`, dan `NotificationService`. Jadi pengguna cukup satu
`import 'package:offline_reminder_engine/offline_reminder_engine.dart';`.

---

## 3. Dependensi dan Lingkungan

Dari `pubspec.yaml`:

| Item | Nilai |
|---|---|
| Nama paket | `offline_reminder_engine` |
| Versi | `0.1.0` |
| Deskripsi | "Offline task scheduler and persistent notification engine for Flutter apps." |
| Dart SDK | `>=3.0.0 <4.0.0` |
| Dependensi runtime | `flutter` (sdk), `flutter_local_notifications ^18.0.1`, `timezone ^0.9.2` |
| Dependensi dev | `flutter_test`, `flutter_lints ^3.0.1` |
| Material | `uses-material-design: true` |

Peran masing-masing dependensi:

- **`flutter_local_notifications`**: menyediakan API untuk membuat notifikasi lokal, membuat channel,
  dan menjadwalkan notifikasi lewat `zonedSchedule`. Bagian native Android (receiver, penyimpanan
  jadwal, pemanggilan `AlarmManager`) ada di plugin ini, bukan di repo.
- **`timezone`**: menyediakan `TZDateTime` dan database zona waktu IANA. `zonedSchedule` mewajibkan
  waktu bertipe `TZDateTime`.

Di dalam `.gitignore` terdapat `/pubspec.lock`, sesuai praktik paket library Dart.

---

## 4. Arsitektur dan Pembagian Tanggung Jawab

```
  Aplikasi pengguna
        │
        │  Reminder(...) , ReminderManager.schedule(...)
        ▼
┌─────────────────────┐
│  ReminderManager    │  Lapisan keputusan ringan:
│  (fasad statis)     │  - lewati jika enabled == false
│                     │  - rebuildAll: batal semua lalu jadwal ulang
└─────────┬───────────┘
          │  NotificationService.scheduleReminder / cancelReminder / cancelAll / init
          ▼
┌─────────────────────┐
│ NotificationService │  Lapisan platform:
│ (singleton statis)  │  - init timezone, plugin, channel
│                     │  - hitung TZDateTime
│                     │  - bangun NotificationDetails
│                     │  - panggil zonedSchedule
└─────────┬───────────┘
          │  FlutterLocalNotificationsPlugin
          ▼
┌─────────────────────┐
│ flutter_local_      │  Native Android: AlarmManager.setAlarmClock,
│ notifications       │  receiver alarm, receiver boot (jika dideklarasikan)
└─────────┬───────────┘
          ▼
   Sistem Android  ──►  Notifikasi tampil pada waktunya
```

Karakteristik desain:

- **Semua method statis.** Tidak ada instance `ReminderManager` atau `NotificationService`.
  State global hanya dua: `_notifications` (instance plugin) dan `_initialized` (flag).
- **Tidak ada penyimpanan.** Daftar pengingat tidak disimpan oleh paket. Sumber kebenaran ada di
  aplikasi pengguna, yang menyerahkan `List<Reminder>` ke `rebuildAll`.
- **Tidak ada state internal pengingat.** Paket tidak tahu pengingat apa yang sedang terjadwal selain
  lewat ID yang dikirim ke plugin.

---

## 5. Model Data: `Reminder`

File: `lib/src/models/reminder.dart` (35 baris).

### 5.1 Field

| Field | Tipe | Default | Fungsi |
|---|---|---|---|
| `id` | `String` | wajib | Identitas pengingat. Di-hash menjadi ID notifikasi integer |
| `type` | `String` | wajib | Teks pengingat. **Dipakai sebagai isi (body) notifikasi**, bukan sebagai kategori |
| `time` | `DateTime` | wajib | Waktu pengingat pertama berbunyi |
| `enabled` | `bool` | `true` | Jika `false`, `schedule` dan `rebuildAll` melewati pengingat ini |
| `repeat` | `String` | `'none'` | Pola ulang. Hanya nilai `'daily'` yang dikenali kode |

Semua field **mutable** (tidak `final`), jadi objek bisa diubah setelah dibuat.

### 5.2 Serialisasi

`toJson()` menghasilkan:

```json
{
  "id": "test",
  "type": "Feed the dog",
  "time": "2026-03-05T08:30:00.000",
  "enabled": true,
  "repeat": "daily"
}
```

- `time` ditulis sebagai string ISO 8601 (`toIso8601String()`). Untuk `DateTime` lokal, string
  tidak memuat offset zona waktu; untuk `DateTime` UTC berakhiran `Z`.
- `fromJson()` membaca balik dengan `DateTime.parse`. Field `enabled` dan `repeat` punya fallback
  (`?? true` dan `?? 'none'`) bila kunci tidak ada.
- `id`, `type`, dan `time` **tidak divalidasi**. Jika kunci hilang atau tipenya salah, akan terjadi
  exception saat runtime.

Serialisasi ini disediakan agar aplikasi bisa menyimpan pengingat (misalnya di `shared_preferences`
atau database), tetapi **paket tidak memanggilnya sendiri** di mana pun.

---

## 6. Lapisan API: `ReminderManager`

File: `lib/src/services/reminder_manager.dart` (45 baris). Semua method `static`.

### 6.1 `initialize()` (baris 7-9)

```dart
static Future<void> initialize() async {
  await NotificationService.init();
}
```

Hanya meneruskan ke `NotificationService.init()`. Ini setara dengan memanggil `init()` langsung.
README memakai `NotificationService.init()`, sedangkan `ReminderManager.initialize()` adalah jalur
alternatif yang hasilnya sama.

### 6.2 `schedule(Reminder)` (baris 12-19)

```dart
if (!reminder.enabled) return;
await NotificationService.scheduleReminder(reminder);
```

- Jika `enabled == false`, method **langsung keluar tanpa melakukan apa pun**. Penting: ia
  **tidak membatalkan** alarm lama dengan ID yang sama. Jadi mematikan pengingat yang sudah
  terjadwal harus dilakukan dengan memanggil `cancel`, bukan dengan `enabled = false` lalu `schedule`.
- Jika aktif, penjadwalan diteruskan ke `NotificationService`.
- Menjadwalkan ulang `Reminder` dengan `id` yang sama akan **menimpa** alarm sebelumnya, karena
  ID notifikasi diturunkan dari `id` (lihat bagian 12).

### 6.3 `cancel(Reminder)` (baris 22-27)

Meneruskan ke `NotificationService.cancelReminder`, yang membatalkan notifikasi/alarm dengan
ID hasil `reminder.id.hashCode`.

### 6.4 `rebuildAll(List<Reminder>)` (baris 30-44)

Urutan kerja:

1. `NotificationService.cancelAll()`: membatalkan **seluruh** notifikasi terjadwal milik plugin
   (bukan hanya yang dibuat paket ini, tetapi semua yang terdaftar lewat instance plugin di aplikasi).
2. Untuk tiap `Reminder` dalam list: lewati yang `enabled == false`, jadwalkan sisanya.

Tujuan yang tersirat dari komentar kode ("Rebuild all reminders on app start"): menjadikan daftar
yang disimpan aplikasi sebagai sumber kebenaran dan menyelaraskan alarm sistem dengannya setiap
aplikasi dibuka. Ini juga berfungsi sebagai jaring pengaman jika alarm hilang.

Tidak ada penanganan error: jika satu `scheduleReminder` melempar exception, loop berhenti dan
sisa pengingat tidak terjadwal, padahal `cancelAll` sudah dijalankan.

---

## 7. Lapisan Platform: `NotificationService`

File: `lib/src/services/notification_service.dart` (102 baris). Semua `static`.

### 7.1 State

```dart
static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
static bool _initialized = false;
```

Satu instance plugin dipakai bersama. `_initialized` mencegah inisialisasi ganda.

### 7.2 `init()` (baris 15-48)

Langkah berurutan:

| # | Baris | Aksi | Keterangan |
|---|---|---|---|
| 1 | 17 | `if (_initialized) return;` | Idempotent: pemanggilan kedua tidak berefek |
| 2 | 19 | `tz.initializeTimeZones()` | Memuat database zona waktu IANA ke memori |
| 3 | 22 | `tz.setLocalLocation(tz.getLocation('Asia/Makassar'))` | Menetapkan zona lokal. **Hard-coded**, lihat bagian 10 |
| 4 | 24-25 | `AndroidInitializationSettings('@mipmap/ic_launcher')` | Ikon notifikasi default = ikon launcher aplikasi |
| 5 | 27-29 | `InitializationSettings(android: androidSettings)` | Hanya Android; tidak ada pengaturan iOS/macOS/Linux |
| 6 | 31 | `await _notifications.initialize(settings)` | Tanpa callback tap notifikasi |
| 7 | 33-39 | Membuat `AndroidNotificationChannel` id `reminders`, nama `Reminders`, `Importance.max` | |
| 8 | 41-45 | `resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()` lalu `createNotificationChannel(channel)` | Tanda `?.` membuat langkah ini aman di platform non-Android |
| 9 | 47 | `_initialized = true` | Flag diset **di akhir**, jadi jika langkah sebelumnya melempar exception, init bisa diulang |

Yang **tidak** dilakukan `init()`:

- Tidak meminta izin notifikasi runtime (`POST_NOTIFICATIONS`, Android 13+).
- Tidak meminta izin exact alarm.
- Tidak mendaftarkan `onDidReceiveNotificationResponse` (ketukan pada notifikasi tidak ditangani).
- Tidak mendeteksi zona waktu perangkat.

### 7.3 `cancelAll()` (baris 51-53)

`await _notifications.cancelAll();`, membatalkan semua notifikasi, baik yang sudah tampil maupun yang terjadwal.

### 7.4 `cancelReminder(Reminder)` (baris 56-58)

`await _notifications.cancel(reminder.id.hashCode);`, membatalkan satu notifikasi/alarm berdasarkan ID integer.

### 7.5 `scheduleReminder(Reminder)` (baris 61-101)

Ini mekanisme inti. Langkahnya:

**Langkah A. Ambil waktu sekarang di zona lokal** (baris 63)

```dart
final now = tz.TZDateTime.now(tz.local);
```

**Langkah B. Konversi waktu pengingat ke `TZDateTime`** (baris 65-66)

```dart
tz.TZDateTime scheduled = tz.TZDateTime.from(reminder.time, tz.local);
```

`TZDateTime.from` mempertahankan **instant (momen absolut)** dari `reminder.time` lalu menyatakannya
di zona `tz.local`.

**Langkah C. Koreksi jika sudah lewat** (baris 69-71)

```dart
if (scheduled.isBefore(now)) {
  scheduled = now.add(const Duration(seconds: 10));
}
```

Jika waktu sudah lewat, jadwal dipindah ke **10 detik dari sekarang**. (Komentar di kode menyebut
"next minute", tetapi implementasinya 10 detik.) Dampaknya dibahas di bagian 14 dan 16.

**Langkah D. Bangun `NotificationDetails`** (baris 72-85)

Detail Android: channel `reminders`, `Importance.max`, `Priority.max`, suara aktif, getar aktif,
ticker `'ticker'`, visibilitas `public`, ikon `@mipmap/ic_launcher`.

**Langkah E. Log debug** (baris 86)

`print("Scheduling notification for $scheduled");`. Memakai `print`, jadi tetap muncul di build rilis.

**Langkah F. Panggil `zonedSchedule`** (baris 87-100)

| Parameter | Nilai | Arti |
|---|---|---|
| `id` | `reminder.id.hashCode` | ID notifikasi |
| `title` | `"Reminder"` | Judul **tetap**, tidak bisa dikustomisasi |
| `body` | `reminder.type` | Isi notifikasi |
| `scheduledDate` | `scheduled` | Waktu bunyi pertama |
| `notificationDetails` | `details` | Tampilan/prioritas |
| `androidScheduleMode` | `AndroidScheduleMode.alarmClock` | Pakai mekanisme alarm jam (lihat bagian 9) |
| `uiLocalNotificationDateInterpretation` | `absoluteTime` | Parameter khusus iOS; tidak berefek di Android |
| `matchDateTimeComponents` | `DateTimeComponents.time` jika `repeat == 'daily'`, selain itu `null` | Mengaktifkan pengulangan harian |

---

## 8. Alur Kerja End-to-End

### 8.1 Inisialisasi (saat aplikasi mulai)

```
main()
  └─ ReminderManager.initialize()   atau   NotificationService.init()
        ├─ cek _initialized (keluar jika sudah true)
        ├─ tz.initializeTimeZones()
        ├─ tz.setLocalLocation('Asia/Makassar')
        ├─ _notifications.initialize(settings)
        ├─ createNotificationChannel('reminders', Importance.max)
        └─ _initialized = true
```

### 8.2 Menjadwalkan satu pengingat

```
ReminderManager.schedule(reminder)
  ├─ enabled == false ? ──► return (tidak ada efek)
  └─ NotificationService.scheduleReminder(reminder)
        ├─ now       = TZDateTime.now(local)
        ├─ scheduled = TZDateTime.from(reminder.time, local)
        ├─ scheduled < now ? ──► scheduled = now + 10 detik
        ├─ build NotificationDetails
        └─ zonedSchedule(id = id.hashCode, ..., alarmClock, match = daily ? time : null)
              └─ [plugin] simpan jadwal + AlarmManager.setAlarmClock(...)
```

### 8.3 Saat waktu tiba (aplikasi tertutup)

```
Android AlarmManager ──► receiver alarm milik plugin ──► tampilkan notifikasi
                                                         │
                                                         └─ jika repeat harian: plugin menjadwalkan
                                                            ulang kemunculan berikutnya
```

Aplikasi Flutter **tidak perlu hidup**. Tidak ada kode Dart paket ini yang berjalan pada saat bunyi.

### 8.4 Membatalkan

```
ReminderManager.cancel(reminder) ──► NotificationService.cancelReminder ──► plugin.cancel(id.hashCode)
```

### 8.5 Rebuild saat aplikasi dibuka

```
ReminderManager.rebuildAll(daftarDariPenyimpanan)
  ├─ NotificationService.cancelAll()
  └─ untuk tiap reminder yang enabled:
        └─ NotificationService.scheduleReminder(reminder)   (alur 8.2)
```

### 8.6 Setelah perangkat restart

**Catatan eksternal.** Kode paket tidak memuat logika boot. Klaim "survives device reboot" di README
bergantung pada plugin `flutter_local_notifications`, yang menyimpan notifikasi terjadwal dan
menjadwalkan ulang lewat `ScheduledNotificationBootReceiver`. Receiver ini harus dideklarasikan di
`AndroidManifest.xml` **aplikasi pengguna** (lihat bagian 17). Selain itu, `rebuildAll` saat aplikasi
dibuka kembali menjadi lapisan pemulihan kedua.

---

## 9. Mekanisme Penjadwalan Android

Paket memakai `AndroidScheduleMode.alarmClock`. **Catatan eksternal** mengenai artinya:

- Plugin memetakan mode ini ke `AlarmManager.setAlarmClock(...)`. Alarm jenis ini diperlakukan sistem
  seperti alarm aplikasi jam: tepat waktu, dan dikecualikan dari penundaan Doze/App Standby.
- Sistem biasanya menampilkan ikon alarm di status bar bila alarm tersebut menjadi alarm berikutnya
  yang akan berbunyi.
- Karena penjadwalan dilakukan di level sistem, mekanisme ini tidak bergantung pada `Timer` Dart,
  WorkManager, atau service latar belakang.

Implikasi bagi paket ini: "andal saat aplikasi ditutup" muncul dari pilihan mode ini ditambah
konfigurasi manifest di aplikasi pengguna, **bukan** dari logika di dalam repo.

Hal yang perlu diverifikasi di dokumentasi plugin dan Android untuk versi yang Anda pakai:

- Apakah `alarmClock` memerlukan izin `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM` pada Android 12+.
- Perilaku pada perangkat dengan penghemat baterai agresif dari vendor (mis. One UI, MIUI, ColorOS).
  Screenshot demo di repo berasal dari perangkat One UI (Samsung).

---

## 10. Mekanisme Zona Waktu

### 10.1 Yang dilakukan kode

```dart
tz.initializeTimeZones();
tz.setLocalLocation(tz.getLocation('Asia/Makassar'));
```

Komentar di kode: `// IMPORTANT: set device timezone`. Namun implementasinya **bukan** mendeteksi zona
perangkat, melainkan **memaksa** `Asia/Makassar` (WITA, UTC+8, tanpa DST).

### 10.2 Konsekuensi

| Skenario | Efek |
|---|---|
| Pengingat sekali jalan (`repeat: 'none'`) | `TZDateTime.from` mempertahankan instant absolut, jadi alarm tetap berbunyi pada momen yang benar di zona mana pun |
| Pengingat harian (`repeat: 'daily'`) | Plugin mencocokkan **jam-menit pada zona `tz.local`** (Makassar). Selama perangkat berada di zona dengan offset tetap yang sama, hasilnya konsisten |
| Pengguna di WIB (UTC+7) atau WIT (UTC+9) | Instant tetap benar; ulang harian mengikuti jam dinding Makassar, yang karena Indonesia tanpa DST tetap konsisten dengan jam dinding lokal pengguna (selisih konstan) |
| Pengguna pindah ke zona dengan DST / offset berbeda | Ulang harian mengikuti jam Makassar, bukan jam dinding lokal pengguna. Pengingat jam 07:00 bisa terasa bergeser |
| `DateTime` dari `Reminder.time` | Dikonversi dengan semantik instant. Jika `time` dibuat sebagai `DateTime` lokal perangkat, instant-nya benar |

Singkatnya, hard-coding aman untuk pengguna di Indonesia (tanpa DST), tetapi tidak akurat untuk
penggunaan lintas zona waktu. Solusi umum adalah membaca zona perangkat (mis. dengan paket
`flutter_timezone`) lalu memanggil `tz.getLocation(...)` dengan hasilnya.

---

## 11. Mekanisme Pengulangan (Repeat)

```dart
matchDateTimeComponents: reminder.repeat == 'daily' ? DateTimeComponents.time : null,
```

- `repeat` bertipe `String` bebas, tetapi **hanya `'daily'`** yang dikenali.
- Nilai lain (`'none'`, `'weekly'`, `'Daily'`, string salah ketik) **diam-diam diperlakukan sebagai sekali jalan**.
  Tidak ada validasi, error, atau peringatan.
- `DateTimeComponents.time` berarti notifikasi muncul **setiap hari pada jam dan menit yang sama** dengan
  `scheduledDate`.
- Kemunculan pertama adalah `scheduled` (waktu pengingat, atau now+10 detik bila sudah lewat).
- Pengulangan mingguan, bulanan, atau pola kustom ada di roadmap dan belum diimplementasikan.

---

## 12. Mekanisme ID Notifikasi

```dart
reminder.id.hashCode
```

dipakai sebagai ID untuk `zonedSchedule` dan `cancel`.

Sifat dan implikasinya:

- **Deterministik dalam satu proses**: `id` string yang sama selalu menghasilkan ID integer yang sama,
  sehingga `schedule` ulang menimpa dan `cancel` menemukan targetnya.
- **Tidak dijamin stabil lintas versi Dart/platform.** Spesifikasi Dart tidak menjanjikan nilai
  `String.hashCode` konsisten antar versi SDK atau antar build. Bila hash berubah setelah update
  SDK, `cancel` bisa gagal menemukan alarm lama yang dibuat dengan hash sebelumnya, sehingga bisa
  muncul duplikat atau alarm yatim.
- **Mungkin bertabrakan**: dua `id` berbeda bisa menghasilkan hash sama (kecil kemungkinannya, tetapi
  tidak nol). Akibatnya satu pengingat menimpa yang lain.
- Plugin menerima ID bertipe integer 32-bit; selama hash berada dalam rentang itu tidak ada masalah.

Alternatif yang lebih aman: simpan ID integer sendiri (counter yang dipersistenkan) di `Reminder`,
atau pakai fungsi hash yang stabil seperti FNV-1a atas `id`.

---

## 13. Channel dan Tampilan Notifikasi

### 13.1 Channel (dibuat di `init`)

| Properti | Nilai |
|---|---|
| ID | `reminders` |
| Nama | `Reminders` |
| Deskripsi | `Reminder notifications` |
| Importance | `Importance.max` |

### 13.2 Detail per notifikasi (di `scheduleReminder`)

| Properti | Nilai |
|---|---|
| Channel ID / nama | `reminders` / `Reminders` |
| `importance` | `Importance.max` |
| `priority` | `Priority.max` |
| `playSound` | `true` |
| `enableVibration` | `true` |
| `ticker` | `'ticker'` |
| `visibility` | `NotificationVisibility.public` (isi tampil di layar kunci) |
| `icon` | `@mipmap/ic_launcher` |
| Judul | `"Reminder"` (tetap) |
| Isi | `reminder.type` |

**Catatan eksternal (Android 8.0+):** setelah channel dibuat, pengaturan suara/getar/importance
dikendalikan oleh channel dan pengguna, bukan oleh `NotificationDetails` per notifikasi. Mengubah nilai
`Importance.max` di kode setelah channel pernah dibuat tidak akan mengubah channel yang sudah ada;
perlu mengganti ID channel atau pengguna menghapus/menginstal ulang aplikasi.

---

## 14. Penanganan Waktu yang Sudah Lewat

Kode (baris 69-71): jika `scheduled.isBefore(now)`, maka `scheduled = now + 10 detik`.

Dampak:

1. **Pengingat sekali jalan yang sudah lewat tidak dibuang**, melainkan **berbunyi 10 detik kemudian**.
   Ini bisa dianggap fitur (tidak kehilangan pengingat) atau bug (pengingat basi berbunyi tiba-tiba),
   tergantung kebutuhan aplikasi.
2. **Pengingat harian yang `time`-nya sudah lewat ikut tergeser.** Karena `scheduled` diganti
   menjadi now+10 detik **sebelum** diberikan ke `zonedSchedule`, jam-menit untuk ulang harian
   ikut berubah menjadi jam-menit saat penjadwalan dilakukan, bukan jam yang diinginkan pengguna.
   Lihat temuan #1 di bagian 16.

---

## 15. Yang Tidak Ada di Repository

Penting agar ekspektasi terhadap README sesuai kenyataan kode:

| Hal | Status |
|---|---|
| Kode native Android (receiver, service, manifest) | Tidak ada; bergantung pada plugin dan manifest aplikasi pengguna |
| Logika restart/boot | Tidak ada di paket; bergantung pada plugin |
| Penyimpanan/persistensi pengingat | Tidak ada (ada di roadmap). Hanya tersedia `toJson`/`fromJson` |
| Permintaan izin notifikasi runtime | Tidak ada |
| Permintaan izin exact alarm | Tidak ada |
| Handler ketukan notifikasi | Tidak ada |
| Deteksi zona waktu perangkat | Tidak ada (hard-coded Asia/Makassar) |
| Pengulangan selain harian | Tidak ada |
| Dukungan iOS | Tidak ada (`InitializationSettings` hanya berisi Android) |
| Judul notifikasi kustom | Tidak ada (tetap `"Reminder"`) |
| Pembaruan/edit pengingat (selain menimpa dengan ID sama) | Tidak ada API khusus |
| Query pengingat terjadwal (`pendingNotificationRequests`) | Tidak diekspos |
| Test unit/integrasi dan contoh aplikasi | Tidak ada folder `test/` maupun `example/` |
| Logging terstruktur | Hanya satu `print` |
| Penanganan error | Tidak ada `try/catch` |

---

## 16. Temuan, Risiko, dan Keterbatasan

Diurutkan dari dampak terbesar. Semua temuan berasal dari pembacaan kode; reproduksi di perangkat
tetap disarankan.

### #1. Pengingat harian bisa bergeser dan berbunyi setiap aplikasi dibuka (dampak tinggi)

`scheduleReminder` mengganti `scheduled` menjadi now+10 detik jika `reminder.time` sudah lewat, lalu
meneruskannya ke `zonedSchedule` dengan `DateTimeComponents.time`. Jam harian jadi mengikuti
saat penjadwalan, bukan jam asli.

Bila aplikasi menyimpan `Reminder` dengan `time` asli (mis. kemarin pukul 07:00) dan memanggil
`rebuildAll` setiap aplikasi dibuka, maka **setiap pembukaan aplikasi** akan:

- membunyikan pengingat harian itu 10 detik kemudian, dan
- menggeser jadwal hariannya ke jam saat aplikasi dibuka.

**Mitigasi:** untuk `repeat == 'daily'`, hitung kemunculan berikutnya dengan menjaga jam-menit asli
(maju per hari sampai melewati `now`), bukan memakai `now + 10 detik`.

### #2. Hash `String` sebagai ID notifikasi (dampak sedang)

Lihat bagian 12: tidak dijamin stabil lintas versi SDK dan bisa bertabrakan.

### #3. Zona waktu di-hardcode (dampak sedang)

Lihat bagian 10. Komentar kode menyebut "set device timezone", padahal nilainya konstan.

### #4. Klaim "survives reboot" tidak dijamin oleh repo (dampak sedang)

Tidak ada kode boot di paket. Pengguna paket harus mengonfigurasi manifest dengan benar dan, idealnya,
memanggil `rebuildAll` saat aplikasi dibuka. README tidak menjelaskan langkah ini.

### #5. Tidak ada permintaan izin (dampak sedang)

Pada Android 13+, tanpa izin `POST_NOTIFICATIONS`, notifikasi tidak akan tampil. Paket tidak memintanya.
Aplikasi pengguna harus melakukannya sendiri.

### #6. `schedule` dengan `enabled == false` tidak membatalkan alarm lama (dampak rendah-sedang)

Alur "matikan pengingat" harus memanggil `cancel`. Bila hanya mengubah `enabled` lalu memanggil
`schedule`, alarm lama tetap hidup.

### #7. `rebuildAll` membatalkan semua notifikasi plugin (dampak rendah-sedang)

`cancelAll()` tidak terbatas pada notifikasi buatan paket ini. Jika aplikasi memakai notifikasi lokal
lain lewat plugin yang sama, semuanya ikut terbatalkan. Selain itu tidak ada penanganan error di tengah
loop.

### #8. `repeat` bertipe string tanpa validasi (dampak rendah)

Nilai tak dikenal diam-diam menjadi sekali jalan. Enum akan lebih aman.

### #9. Ketukan notifikasi tidak ditangani (dampak rendah)

`initialize` dipanggil tanpa callback respons notifikasi, sehingga tidak ada navigasi atau aksi saat
pengguna mengetuk notifikasi.

### #10. Pemanggilan sebelum `init()` (dampak rendah)

Tidak ada auto-init. Memanggil `schedule` sebelum `init` akan gagal karena zona waktu lokal dan
plugin belum disiapkan.

### #11. Kualitas kemasan repo (dampak rendah)

- `CHANGELOG.md` masih template dan tidak sinkron dengan versi `0.1.0`.
- Screenshot ~1,2 MB di root repo; sebaiknya dipindah ke `docs/` dan dikompres.
- Komentar "next minute" tidak cocok dengan kode (10 detik).
- `print` dipakai untuk logging; sebaiknya `debugPrint` atau `kDebugMode`.
- Tidak ada `test/` dan `example/`, yang biasanya diharapkan pub.dev.
- `uiLocalNotificationDateInterpretation` adalah parameter yang dihapus di versi plugin yang lebih baru;
  upgrade plugin di masa depan akan memerlukan penyesuaian kode.

---

## 17. Checklist Integrasi ke Aplikasi

Karena paket tidak memuat kode native, aplikasi pengguna perlu menyiapkan hal berikut. **Verifikasi
dengan dokumentasi `flutter_local_notifications` versi 18** karena detail manifest bisa berubah.

1. **Tambahkan dependensi** di `pubspec.yaml` aplikasi (README memakai path lokal):

   ```yaml
   dependencies:
     offline_reminder_engine:
       path: ../offline_reminder_engine
   ```

2. **Izin di `AndroidManifest.xml`** (umumnya diperlukan):
   - `POST_NOTIFICATIONS` (Android 13+)
   - `RECEIVE_BOOT_COMPLETED` (agar jadwal dipulihkan setelah restart)
   - `SCHEDULE_EXACT_ALARM` atau `USE_EXACT_ALARM` bila dibutuhkan untuk mode yang dipakai

3. **Deklarasi receiver plugin** di dalam `<application>`:
   - `ScheduledNotificationReceiver`
   - `ScheduledNotificationBootReceiver` (dengan intent filter `BOOT_COMPLETED`)

4. **Core library desugaring** bila diminta plugin untuk versi Android Gradle Plugin yang dipakai.

5. **Pastikan ikon `@mipmap/ic_launcher` ada** (kode memakainya untuk ikon notifikasi).

6. **Panggil init saat start**:

   ```dart
   WidgetsFlutterBinding.ensureInitialized();
   await ReminderManager.initialize();
   ```

7. **Minta izin notifikasi runtime** di aplikasi (paket tidak melakukannya).

8. **Simpan daftar `Reminder`** di penyimpanan aplikasi (pakai `toJson`/`fromJson`) dan panggil
   `ReminderManager.rebuildAll(daftar)` saat aplikasi dibuka, dengan memperhatikan temuan #1.

9. **Uji di perangkat nyata** dengan aplikasi ditutup (swipe dari recent apps), perangkat di-restart,
   dan mode hemat baterai aktif.

---

## 18. Contoh Penggunaan Lengkap

### 18.1 Seperti di README

```dart
import 'package:offline_reminder_engine/offline_reminder_engine.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();   // atau: await ReminderManager.initialize();

  final reminder = Reminder(
    id: "test",
    type: "Feed the dog",
    time: DateTime.now().add(Duration(minutes: 10)),
  );

  await ReminderManager.schedule(reminder);
  runApp(const MyApp());
}
```

### 18.2 Pengingat harian

```dart
final daily = Reminder(
  id: "obat-pagi",
  type: "Minum obat",
  time: DateTime(2026, 10, 2, 7, 0),   // pertama kali: 2 Okt 2026 pukul 07:00
  repeat: 'daily',
);
await ReminderManager.schedule(daily);
```

Selama `time` masih di masa depan saat dijadwalkan, jadwal harian jatuh pada 07:00. Bila `time`
sudah lewat saat `schedule` dipanggil, berlaku temuan #1.

### 18.3 Membatalkan dan mematikan

```dart
await ReminderManager.cancel(daily);   // cara yang benar untuk mematikan alarm yang sudah terjadwal
```

### 18.4 Menyimpan dan memulihkan

```dart
// simpan
final jsonList = reminders.map((r) => r.toJson()).toList();

// pulihkan saat aplikasi dibuka
final restored = jsonList.map((m) => Reminder.fromJson(m)).toList();
await ReminderManager.rebuildAll(restored);
```

---

## 19. Status Proyek, Roadmap, Riwayat Git, Lisensi

**Status (README):** tahap awal; engine sudah dipakai di aplikasi nyata dan sedang diekstrak menjadi paket
yang dapat dipakai ulang.

**Roadmap (README):**

- Pengingat mingguan
- Jadwal pengulangan kustom
- Penyimpanan pengingat persisten (opsional)
- Dukungan iOS
- Publikasi di pub.dev

**Riwayat Git:** 13 commit antara 3 dan 6 Maret 2026.

| Tanggal | Aktivitas |
|---|---|
| 3 Mar 2026 | Initial commit; ganti `LICENSE` menjadi `LICENSE.txt` |
| 5 Mar 2026 | Pembaruan LICENSE dan sejumlah revisi README; upload screenshot demo (`cc5fed8`) |
| 6 Mar 2026 | Revisi README terakhir (`fdf3720`, `ddfb4d3`) |

Sebagian besar commit mengubah README; kode `lib/` relatif stabil dan kecil.

**Lisensi:** MIT.

**Dukungan proyek (README):** tautan Buy Me a Coffee milik pemilik repo.

---

## 20. Peta Referensi File dan Baris

| Topik | File | Baris |
|---|---|---|
| Barrel export | `lib/offline_reminder_engine.dart` | 1-5 |
| Definisi `Reminder` | `lib/src/models/reminder.dart` | 1-14 |
| `toJson` | `lib/src/models/reminder.dart` | 16-24 |
| `fromJson` | `lib/src/models/reminder.dart` | 26-34 |
| `ReminderManager.initialize` | `lib/src/services/reminder_manager.dart` | 7-9 |
| `ReminderManager.schedule` | `lib/src/services/reminder_manager.dart` | 12-19 |
| `ReminderManager.cancel` | `lib/src/services/reminder_manager.dart` | 22-27 |
| `ReminderManager.rebuildAll` | `lib/src/services/reminder_manager.dart` | 30-44 |
| Instance plugin & flag init | `lib/src/services/notification_service.dart` | 9-12 |
| `init` | `lib/src/services/notification_service.dart` | 15-48 |
| Zona waktu hard-coded | `lib/src/services/notification_service.dart` | 19-22 |
| Pembuatan channel | `lib/src/services/notification_service.dart` | 33-45 |
| `cancelAll` | `lib/src/services/notification_service.dart` | 51-53 |
| `cancelReminder` | `lib/src/services/notification_service.dart` | 56-58 |
| `scheduleReminder` | `lib/src/services/notification_service.dart` | 61-101 |
| Koreksi waktu lewat (+10 detik) | `lib/src/services/notification_service.dart` | 69-71 |
| `NotificationDetails` | `lib/src/services/notification_service.dart` | 72-85 |
| `zonedSchedule` + mode alarm + repeat | `lib/src/services/notification_service.dart` | 87-100 |

---

*Dokumen ini dibuat berdasarkan kode pada commit `ddfb4d3`. Bagian bertanda "catatan eksternal"
menjelaskan perilaku plugin dan Android yang tidak berada di repository dan perlu dicek terhadap
dokumentasi resmi versi yang digunakan.*
