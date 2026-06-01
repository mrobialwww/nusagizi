import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/router.dart';

import 'package:nusagizi/features/mother/development/domain/entities/kpsp_domain.dart';
import 'package:nusagizi/features/mother/development/domain/entities/kpsp_question.dart';

class KpspResultPage extends StatelessWidget {
  final String childName;
  final String childAge;
  final List<KpspQuestion> questions;
  final List<bool> answers;

  const KpspResultPage({
    super.key,
    required this.childName,
    required this.childAge,
    required this.questions,
    required this.answers,
  });

  static const Color _green = Color(0xFF3CB648);
  static const Color _lightGreen = Color(0xFFDDEFDD);

  IconData _getIconForDomain(KpspDomain domain) {
    switch (domain) {
      case KpspDomain.motorikKasar:
        return Icons.directions_run_rounded;
      case KpspDomain.motorikHalus:
        return Icons.draw_rounded;
      case KpspDomain.bicaraBahasa:
        return Icons.record_voice_over_rounded;
      case KpspDomain.sosialisasiKemandirian:
        return Icons.people_alt_rounded;
    }
  }

  // ─── Kalkulasi Skor ────────────────────────────────────────────────────────

  int get _totalScore => answers.where((a) => a).length;
  int get _totalQuestions => questions.length;

  /// Skor per domain: {domain: (benar, total)}
  Map<KpspDomain, (int, int)> get _domainScores {
    final Map<KpspDomain, (int, int)> result = {};
    for (int i = 0; i < questions.length; i++) {
      final domain = questions[i].domain;
      final current = result[domain] ?? (0, 0);
      result[domain] = (current.$1 + (answers[i] ? 1 : 0), current.$2 + 1);
    }
    return result;
  }

  String get _statusLabel {
    final score = _totalScore;
    if (score >= 8) return 'Sesuai Harapan';
    if (score >= 5) return 'Meragukan';
    return 'Menyimpang';
  }

  Color get _statusColor {
    if (_totalScore >= 8) return _green;
    if (_totalScore >= 5) return const Color(0xFFFF9800);
    return const Color(0xFFE53935);
  }

  Color get _statusBgColor {
    if (_totalScore >= 8) return _lightGreen;
    if (_totalScore >= 5) return const Color(0xFFFFEBD6);
    return const Color(0xFFFFEBEE);
  }

  String get _summaryTitle {
    if (_totalScore >= 8) return 'Perkembangan Sangat Baik';
    if (_totalScore >= 5) return 'Perkembangan Meragukan';
    return 'Perkembangan Menyimpang';
  }

  String get _summaryDesc {
    if (_totalScore >= 8) {
      return 'Hebat! Perkembangan $childName saat ini sesuai dengan tahap umurnya. Terus berikan stimulasi yang menyenangkan ya Bunda.';
    }
    if (_totalScore >= 5) {
      return 'Perkembangan $childName perlu dipantau lebih lanjut. Coba lakukan stimulasi di area yang belum optimal.';
    }
    return 'Perkembangan $childName memerlukan perhatian khusus. Segera konsultasikan dengan tenaga kesehatan.';
  }

  List<String> get _recommendations {
    final domainScores = _domainScores;
    final List<String> recs = [];

    // Cari domain dengan skor rendah
    domainScores.forEach((domain, score) {
      final ratio = score.$2 > 0 ? score.$1 / score.$2 : 1.0;
      if (ratio < 1.0) {
        switch (domain) {
          case KpspDomain.motorikKasar:
            recs.add(
              'Fokus Stimulasi Motorik Kasar\nAjak ${childName} bermain lempar-tangkap bola atau berjalan di permukaan tidak rata untuk melatih keseimbangan.',
            );
            break;
          case KpspDomain.motorikHalus:
            recs.add(
              'Fokus Stimulasi Motorik Halus\nLatih ${childName} dengan aktivitas seperti mewarnai, menyusun puzzle kecil, atau meronce manik-manik besar.',
            );
            break;
          case KpspDomain.bicaraBahasa:
            recs.add(
              'Fokus Stimulasi Bicara & Bahasa\nSeringlah bercerita dan bernyanyi bersama ${childName}. Tunjuk benda-benda di sekitar dan sebut namanya secara perlahan.',
            );
            break;
          case KpspDomain.sosialisasiKemandirian:
            recs.add(
              'Fokus Stimulasi Sosialisasi\nAjak ${childName} bermain peran atau membersihkan mainan bersama untuk melatih ${childName} berinteraksi saat bermain.',
            );
            break;
        }
      }
    });

    if (recs.isEmpty) {
      recs.add(
        'Pertahankan Stimulasi Positif\nTerus berikan aktivitas bermain yang variatif untuk mendukung perkembangan ${childName} yang sudah sangat baik.',
      );
    }

    recs.add(
      'Jadwal Ulang KPSP\nLakukan tes KPSP kembali pada usia 30 bulan untuk memantau perkembangan selanjutnya.',
    );
    return recs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSummaryCard(),
                    const SizedBox(height: 16),
                    _buildDomainCard(context),
                    const SizedBox(height: 16),
                    _buildRecommendationCard(),
                    const SizedBox(height: 24),
                    _buildSaveButton(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.goNamed(AppRoutes.development.name),
            child: const Icon(
              Icons.arrow_back,
              size: 22,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hasil Asesmen KPSP',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  childAge,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: Implementasi share
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.share_outlined,
                size: 18,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _statusBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _statusColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Badge status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: _statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 14, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  _statusLabel,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Skor besar
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$_totalScore',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    fontSize: 52,
                    color: Colors.black87,
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: '/$_totalQuestions',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _summaryTitle,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            _summaryDesc,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainCard(BuildContext context) {
    final domainScores = _domainScores;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart, size: 24, color: _green),
              const SizedBox(width: 8),
              Text(
                'Rincian Domain',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: domainScores.entries.map((entry) {
              final domain = entry.key;
              final score = entry.value;
              final isGood = score.$2 > 0 && score.$1 == score.$2;
              return _buildDomainScoreItem(
                context: context,
                domain: domain,
                score: score.$1,
                total: score.$2,
                isGood: isGood,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard() {
    final recs = _recommendations;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment, size: 24, color: _green),
              const SizedBox(width: 8),
              Text(
                'Rekomendasi Selanjutnya',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...recs.map((rec) {
            final parts = rec.split('\n');
            final isLast = rec == recs.last;
            final icon = isLast
                ? Icons.calendar_month_outlined
                : Icons.extension;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDDEFDD),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 20, color: _green),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: const Color(0xFFE0E0E0),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              parts[0],
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            if (parts.length > 1) ...[
                              const SizedBox(height: 6),
                              Text(
                                parts[1],
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Implementasi simpan ke riwayat
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Berhasil disimpan ke riwayat!',
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: _green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _green, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'Simpan ke Riwayat',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: _green,
          ),
        ),
      ),
    );
  }

  Widget _buildDomainScoreItem({
    required BuildContext context,
    required KpspDomain domain,
    required int score,
    required int total,
    required bool isGood,
  }) {
    final itemWidth = (MediaQuery.of(context).size.width - 72 - 12) / 2;
    return Container(
      width: itemWidth,
      height: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isGood ? const Color(0xFFDDEFDD) : const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForDomain(domain),
              size: 20,
              color: isGood ? _green : Colors.black45,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  domain.label == 'Sosialisasi & Kemandirian'
                      ? 'Sosialisasi'
                      : domain.label,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$score/$total',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
