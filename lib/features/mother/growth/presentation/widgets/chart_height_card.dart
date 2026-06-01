import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/domain/entities/child_profile.dart';
import 'package:nusagizi/core/domain/entities/growth_record.dart';
import 'package:nusagizi/core/widgets/app_card.dart';
import 'package:nusagizi/features/mother/growth/presentation/models/bb_sub_page_config.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/growth_chart_content.dart';

class ChartHeightCard extends StatelessWidget {
  final GrowthRecord latest;
  final ChildProfile profile;
  final List<GrowthRecord> history;

  const ChartHeightCard({
    super.key,
    required this.latest,
    required this.profile,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final cfg = BbSubPageConfig(
      title: 'Tinggi Badan Sesuai Usia',
      subtitle: '${latest.height.toInt()} cm / ${profile.ageString} 28 Hari',
      graficLabel: 'Grafik CDC',
      yAxisLabel: 'Tinggi(cm)',
      xAxisLabel: 'Usia (tahun)',
      spots: _spotsHeight(),
      minX: 0,
      maxX: 3,
      minY: 45,
      maxY: 100,
      isMonths: false,
    );

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                Text(
                  cfg.title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  cfg.subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.black45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GrowthChartContent(
              config: cfg,
              childName: profile.name,
              accentColor: const Color(0xFF3CB648),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────
  double _ageInYears(DateTime date) =>
      date.difference(profile.birthDate).inDays / 365.25;

  /// TB/U — tinggi badan terhadap usia (tahun)
  List<FlSpot> _spotsHeight() => history.map((r) {
    final age = _ageInYears(r.date);
    return FlSpot(double.parse(age.toStringAsFixed(2)), r.height);
  }).toList();
}
