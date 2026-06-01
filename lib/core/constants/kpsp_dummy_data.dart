import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/features/mother/development/domain/entities/kpsp_domain.dart';
import 'package:nusagizi/features/mother/development/domain/entities/kpsp_question.dart';

/// Dummy data 10 soal KPSP untuk anak usia 24 bulan.
/// Distribusi: 2 Motorik Kasar, 2 Motorik Halus, 3 Bicara & Bahasa, 3 Sosialisasi & Kemandirian.
///
/// Siap untuk integrasi API:
/// - Ganti list ini dengan hasil fetch dari API
/// - Gunakan `KpspQuestion.fromJson(json)` untuk mapping
final List<KpspQuestion> kpspDummyQuestions = [
  // ─── Motorik Kasar (2 soal) ───────────────────────────────────────────────
  KpspQuestion(
    id: 1,
    domain: KpspDomain.motorikKasar,
    question:
        'Apakah [nama] dapat berjalan mundur 5 langkah atau lebih tanpa kehilangan keseimbangan?',
    hint:
        'Pastikan [nama] tidak berpegangan pada benda apa pun saat melakukannya. Anda dapat mencontohkan terlebih dahulu agar [nama] memahami instruksinya.',
    imagePath: AppImages.asesment1,
  ),
  KpspQuestion(
    id: 2,
    domain: KpspDomain.motorikKasar,
    question:
        'Apakah [nama] dapat melompat dengan dua kaki secara bersamaan dari posisi berdiri?',
    hint:
        'Ajak [nama] bermain melompat di atas lantai yang aman. Amati apakah kedua kakinya terangkat dari lantai secara bersamaan.',
    imagePath: AppImages.asesment2,
  ),

  // ─── Motorik Halus (2 soal) ───────────────────────────────────────────────
  KpspQuestion(
    id: 3,
    domain: KpspDomain.motorikHalus,
    question:
        'Apakah [nama] dapat menyusun minimal 4 balok secara vertikal tanpa menjatuhkannya?',
    hint:
        'Berikan balok atau benda yang dapat ditumpuk. Amati apakah [nama] dapat menyusunnya secara mandiri.',
    imagePath: AppImages.asesment3,
  ),
  KpspQuestion(
    id: 4,
    domain: KpspDomain.motorikHalus,
    question:
        'Apakah [nama] dapat membuka halaman buku satu per satu dengan jari?',
    hint:
        'Berikan buku bergambar kepada [nama]. Amati apakah [nama] dapat membalik halamannya satu per satu, bukan sekaligus.',
    imagePath: AppImages.asesment4,
  ),

  // ─── Bicara & Bahasa (3 soal) ─────────────────────────────────────────────
  KpspQuestion(
    id: 5,
    domain: KpspDomain.bicaraBahasa,
    question:
        'Apakah [nama] dapat mengikuti instruksi sederhana dua langkah, seperti "Ambil bola, lalu taruh di kotak"?',
    hint:
        'Coba berikan instruksi seperti: "Ambil sendok" atau "Tutup pintu." Lihat apakah [nama] memahami perintah sederhana.',
    imagePath: AppImages.asesment1,
  ),
  KpspQuestion(
    id: 6,
    domain: KpspDomain.bicaraBahasa,
    question:
        'Apakah [nama] sudah dapat menyebut minimal 50 kata yang dapat dimengerti?',
    hint:
        'Perhatikan kosakata yang biasa digunakan [nama] sehari-hari. Kata-kata seperti "mama", "makan", "mau" dihitung sebagai satu kata.',
    imagePath: AppImages.asesment2,
  ),
  KpspQuestion(
    id: 7,
    domain: KpspDomain.bicaraBahasa,
    question:
        'Apakah [nama] dapat menyebut nama benda yang ada di sekitarnya (kursi, meja, sepatu) dengan benar?',
    hint:
        'Tunjuk beberapa benda di sekitar [nama] dan tanyakan "Ini apa?" Amati apakah [nama] dapat menjawab dengan benar.',
    imagePath: AppImages.asesment3,
  ),

  // ─── Sosialisasi & Kemandirian (3 soal) ───────────────────────────────────
  KpspQuestion(
    id: 8,
    domain: KpspDomain.sosialisasiKemandirian,
    question:
        'Apakah [nama] mau bermain dengan anak lain atau orang di sekitarnya?',
    hint:
        'Amati apakah [nama] menunjukkan ketertarikan untuk berinteraksi saat bermain, seperti mendekati anak lain atau berbagi mainan.',
    imagePath: AppImages.asesment4,
  ),
  KpspQuestion(
    id: 9,
    domain: KpspDomain.sosialisasiKemandirian,
    question:
        'Apakah [nama] dapat makan sendiri menggunakan sendok tanpa banyak tumpah?',
    hint:
        'Berikan [nama] sendok saat makan. Amati apakah [nama] dapat membawa makanan dari piring ke mulutnya secara mandiri.',
    imagePath: AppImages.asesment1,
  ),
  KpspQuestion(
    id: 10,
    domain: KpspDomain.sosialisasiKemandirian,
    question:
        'Apakah [nama] menunjukkan emosi yang jelas seperti senang, sedih, atau marah pada situasi yang sesuai?',
    hint:
        'Perhatikan ekspresi wajah dan reaksi [nama] dalam berbagai situasi sehari-hari. Apakah emosinya sesuai konteks?',
    imagePath: AppImages.asesment2,
  ),
];
