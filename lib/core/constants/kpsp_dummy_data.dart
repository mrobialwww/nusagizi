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
    id: '1',
    domain: 'gross_motor_skills',
    question:
        'Apakah [nama] dapat berjalan mundur 5 langkah atau lebih tanpa kehilangan keseimbangan?',
    monthTarget: 24,
  ),
  KpspQuestion(
    id: '2',
    domain: 'gross_motor_skills',
    question:
        'Apakah [nama] dapat melompat dengan dua kaki secara bersamaan dari posisi berdiri?',
    monthTarget: 24,
  ),

  // ─── Motorik Halus (2 soal) ───────────────────────────────────────────────
  KpspQuestion(
    id: '3',
    domain: 'fine_motor_skills',
    question:
        'Apakah [nama] dapat menyusun minimal 4 balok secara vertikal tanpa menjatuhkannya?',
    monthTarget: 24,
  ),
  KpspQuestion(
    id: '4',
    domain: 'fine_motor_skills',
    question:
        'Apakah [nama] dapat membuka halaman buku satu per satu dengan jari?',
    monthTarget: 24,
  ),

  // ─── Bicara & Bahasa (3 soal) ─────────────────────────────────────────────
  KpspQuestion(
    id: '5',
    domain: 'speech_and_language',
    question:
        'Apakah [nama] dapat mengikuti instruksi sederhana dua langkah, seperti "Ambil bola, lalu taruh di kotak"?',
    monthTarget: 24,
  ),
  KpspQuestion(
    id: '6',
    domain: 'speech_and_language',
    question:
        'Apakah [nama] sudah dapat menyebut minimal 50 kata yang dapat dimengerti?',
    monthTarget: 24,
  ),
  KpspQuestion(
    id: '7',
    domain: 'speech_and_language',
    question:
        'Apakah [nama] dapat menyebut nama benda yang ada di sekitarnya (kursi, meja, sepatu) dengan benar?',
    monthTarget: 24,
  ),

  // ─── Sosialisasi & Kemandirian (3 soal) ───────────────────────────────────
  KpspQuestion(
    id: '8',
    domain: 'socialization',
    question:
        'Apakah [nama] mau bermain dengan anak lain atau orang di sekitarnya?',
    monthTarget: 24,
  ),
  KpspQuestion(
    id: '9',
    domain: 'socialization',
    question:
        'Apakah [nama] dapat makan sendiri menggunakan sendok tanpa banyak tumpah?',
    monthTarget: 24,
  ),
  KpspQuestion(
    id: '10',
    domain: 'socialization',
    question:
        'Apakah [nama] menunjukkan emosi yang jelas seperti senang, sedih, atau marah pada situasi yang sesuai?',
    monthTarget: 24,
  ),
];
