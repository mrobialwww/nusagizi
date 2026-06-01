import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/domain/entities/child_profile.dart';
import 'package:nusagizi/core/domain/entities/growth_record.dart';
import 'package:nusagizi/core/widgets/app_card.dart';
import 'package:nusagizi/features/mother/growth/presentation/models/bb_sub_page_config.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/growth_chart_content.dart';

class ChartHeadCircumference extends StatelessWidget {
  final GrowthRecord latest;
  final ChildProfile profile;
  final List<GrowthRecord> history;

  const ChartHeadCircumference({
    super.key,
    required this.latest,
    required this.profile,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final cfg = BbSubPageConfig(
      title: 'Lingkar Kepala Sesuai Usia',
      subtitle:
          '${latest.headCircumference.toInt()} cm / ${profile.ageString} 28 Hari',
      graficLabel: 'Grafik WHO',
      yAxisLabel: 'L.Kepala(cm)',
      xAxisLabel: 'Usia(bulan)',
      spots: _spotsHeadCirc(),
      minX: 0,
      maxX: 27,
      minY: 30,
      maxY: 70,
      isMonths: true,
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
  double _ageInMonths(DateTime date) =>
      date.difference(profile.birthDate).inDays / 30.44;

  /// LK/U — lingkar kepala terhadap usia (bulan)
  List<FlSpot> _spotsHeadCirc() => history.map((r) {
    final months = _ageInMonths(r.date);
    return FlSpot(double.parse(months.toStringAsFixed(1)), r.headCircumference);
  }).toList();
}
