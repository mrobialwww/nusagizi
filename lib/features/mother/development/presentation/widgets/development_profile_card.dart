import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/routes/route_args.dart';
import 'package:nusagizi/features/mother/development/presentation/widgets/development_radar_chart.dart';

class DevelopmentProfileCard extends StatelessWidget {
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

  const DevelopmentProfileCard({
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

  @override
  Widget build(BuildContext context) {
    const Color greenColor = Color(0xFF3CB648);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          GestureDetector(
            onTap: () {
              context.goNamed(
                AppRoutes.developmentProfileDetail.name,
                extra: DevelopmentProfileDetailExtra(
                  childName: childName,
                  childAge: childAge,
                  motorikHalus: motorikHalus,
                  motorikKasar: motorikKasar,
                  sosialisasi: sosialisasi,
                  bicara: bicara,
                  motorikHalusStatus: motorikHalusStatus,
                  motorikKasarStatus: motorikKasarStatus,
                  sosialisasiStatus: sosialisasiStatus,
                  bicaraStatus: bicaraStatus,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil Perkembangan',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Berdasarkan asesmen terakhir',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          DevelopmentRadarChart(
            motorikHalus: motorikHalus,
            motorikKasar: motorikKasar,
            sosialisasi: sosialisasi,
            bicara: bicara,
            color: greenColor,
            height: 220,
            tickCount: 4,
            borderWidth: 1.5,
            radarBorderColor: Colors.transparent,
            gridBorderColor: Colors.grey.withOpacity(0.3),
            titleTextStyle: const TextStyle(fontSize: 9, color: Colors.black87),
          ),
          const SizedBox(height: 24),
          // Legend
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem('Motorik Kasar', motorikKasarStatus),
                    const SizedBox(height: 8),
                    _legendItem('Bicara & Bahasa', bicaraStatus),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem('Motorik Halus', motorikHalusStatus),
                    const SizedBox(height: 8),
                    _legendItem('Sosialisasi', sosialisasiStatus),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, String status) {
    const Color greenColor = Color(0xFF3CB648);
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: greenColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ',
          style: GoogleFonts.outfit(fontSize: 10, color: Colors.black87),
        ),
        Text(
          '($status)',
          style: GoogleFonts.outfit(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }
}
