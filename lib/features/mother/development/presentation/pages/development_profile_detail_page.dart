import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/features/mother/development/domain/entities/kpsp_domain.dart';
import 'package:nusagizi/features/mother/development/presentation/widgets/development_radar_chart.dart';

class DevelopmentProfileDetailPage extends StatelessWidget {
  final String childName;
  final String childAge;
  final double motorikHalus;
  final double motorikKasar;
  final double sosialisasi;
  final double bicara;
  final String motorikHalusStatus;
  final String motorikKasarStatus;
  final String sosialisasiStatus;
  final String bicaraStatus;

  const DevelopmentProfileDetailPage({
    super.key,
    required this.childName,
    required this.childAge,
    required this.motorikHalus,
    required this.motorikKasar,
    required this.sosialisasi,
    required this.bicara,
    required this.motorikHalusStatus,
    required this.motorikKasarStatus,
    required this.sosialisasiStatus,
    required this.bicaraStatus,
  });

  static const Color _green = Color(0xFF3CB648);
  static const Color _bg = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              'Profil Perkembangan',
              style: GoogleFonts.outfit(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              childAge,
              style: GoogleFonts.outfit(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRadarChartCard(),
            const SizedBox(height: 24),
            Text(
              'Detail Domain',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailList(),
            const SizedBox(height: 24),
            _buildTrendCard(),
            const SizedBox(height: 24),
            Text(
              'Rekomendasi Hari Ini',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            _buildRecommendationCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRadarChartCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
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
          Text(
            'Ringkasan Domain',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Skor perkembangan anak bulan ini',
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          DevelopmentRadarChart(
            motorikHalus: _getPercentage(KpspDomain.motorikHalus),
            motorikKasar: _getPercentage(KpspDomain.motorikKasar),
            sosialisasi: _getPercentage(KpspDomain.sosialisasiKemandirian),
            bicara: _getPercentage(KpspDomain.bicaraBahasa),
            color: _green,
          ),
        ],
      ),
    );
  }

  double _getPercentage(KpspDomain domain) {
    switch (domain) {
      case KpspDomain.motorikHalus:
        return motorikHalus * 100;
      case KpspDomain.motorikKasar:
        return motorikKasar * 100;
      case KpspDomain.sosialisasiKemandirian:
        return sosialisasi * 100;
      case KpspDomain.bicaraBahasa:
        return bicara * 100;
    }
  }

  Widget _buildDetailList() {
    final domains = [
      (KpspDomain.motorikKasar, motorikKasar, motorikKasarStatus),
      (KpspDomain.motorikHalus, motorikHalus, motorikHalusStatus),
      (KpspDomain.bicaraBahasa, bicara, bicaraStatus),
      (KpspDomain.sosialisasiKemandirian, sosialisasi, sosialisasiStatus),
    ];

    return Column(
      children: domains.map((entry) {
        final domain = entry.$1;
        final percentage = entry.$2 * 100;
        final status = entry.$3;
        final isGood = status.toLowerCase() == 'sesuai';

        IconData icon = Icons.check;
        String desc = '';
        switch (domain) {
          case KpspDomain.motorikKasar:
            icon = Icons.directions_run_rounded;
            desc =
                '$childName sudah mulai bisa berjalan tanpa bantuan sejauh beberapa langkah.';
            break;
          case KpspDomain.motorikHalus:
            icon = Icons.draw_rounded;
            desc =
                'Perlu latihan lebih sering untuk menyusun 3-4 balok mainan.';
            break;
          case KpspDomain.bicaraBahasa:
            icon = Icons.record_voice_over_rounded;
            desc =
                'Mampu mengucapkan 5-10 kata dengan jelas dengan menunjuk objek.';
            break;
          case KpspDomain.sosialisasiKemandirian:
            icon = Icons.people_alt_rounded;
            desc =
                '$childName mulai mampu untuk makan sendiri dan berinteraksi dengan orang terdekat.';
            break;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 20, color: _green),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          domain.label,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${percentage.toInt()}% Tercapai',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isGood
                          ? const Color(0xFFDDEFDD)
                          : const Color(0xFFFFE5D9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isGood ? _green : const Color(0xFFF26E22),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                desc,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrendCard() {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF075E26),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: -40,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                AppImages.growth,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tren Perkembangan',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '+15%',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Peningkatan Motorik Kasar bulan ini',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAE1), // Light orange background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Color(0xFFF26E22),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waktu Membaca Bersama',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ajak anak membaca buku bergambar bersama untuk meningkatkan perbendaharaan kata dan kemampuan bahasa.',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.black87,
                    height: 1.5,
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
