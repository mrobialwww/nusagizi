import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/domain/entities/child_profile.dart';
import 'package:nusagizi/core/domain/entities/growth_record.dart';
import 'package:nusagizi/core/widgets/app_card.dart';
import 'package:nusagizi/features/mother/growth/presentation/models/bb_sub_page_config.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/growth_chart_content.dart';

class ChartWeightCard extends StatelessWidget {
  final Color accentColor;
  final GrowthRecord latest;
  final ChildProfile profile;
  final List<GrowthRecord> history;

  final int bbSubPage;
  final PageController bbPageController;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const ChartWeightCard({
    super.key,
    required this.latest,
    required this.profile,
    required this.history,
    required this.bbSubPage,
    required this.bbPageController,
    required this.onPageChanged,
    required this.onPrev,
    required this.onNext,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final subPages = [
      BbSubPageConfig(
        title: 'Berat Badan Sesuai Usia',
        subtitle: '${latest.weight} kg / ${profile.ageString} 28 Hari',
        graficLabel: 'Grafik CDC',
        yAxisLabel: 'Berat(kg)',
        xAxisLabel: 'Usia (tahun)',
        spots: _spotsWeightForAge(),
        minX: 0,
        maxX: 3,
        minY: 0,
        maxY: 20,
        isMonths: false,
      ),
      BbSubPageConfig(
        title: 'Berat Badan vs Tinggi Badan',
        subtitle: '${latest.weight} kg / ${latest.height.toInt()} cm',
        graficLabel: 'Grafik WHO',
        yAxisLabel: 'Berat(kg)',
        xAxisLabel: 'Tinggi (cm)',
        spots: _spotsWeightForHeight(),
        minX: 45,
        maxX: 95,
        minY: 0,
        maxY: 30,
        isMonths: false,
      ),
      BbSubPageConfig(
        title: 'Indeks Massa Tubuh Sesuai Usia',
        subtitle:
            '${_bmiLatest.toStringAsFixed(1)} kg/m² / ${profile.ageString} 28 Hari',
        graficLabel: 'Grafik WHO',
        yAxisLabel: 'IMT(kg/m²)',
        xAxisLabel: 'Usia (tahun)',
        spots: _spotsBmi(),
        minX: 0,
        maxX: 3,
        minY: 10,
        maxY: 35,
        isMonths: false,
      ),
    ];

    final cfg = subPages[bbSubPage];

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Judul & chevron navigasi sub-halaman
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
            child: Row(
              children: [
                Visibility(
                  visible: bbSubPage > 0,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: GestureDetector(
                    onTap: onPrev,
                    child: const Icon(
                      Icons.chevron_left,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(
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
                Visibility(
                  visible: bbSubPage < 2,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: GestureDetector(
                    onTap: onNext,
                    child: const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Dot indicator sub-halaman
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final isActive = i == bbSubPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? accentColor
                      : Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          // PageView grafik (swipeable)
          SizedBox(
            height: 290,
            child: PageView.builder(
              controller: bbPageController,
              itemCount: 3,
              onPageChanged: onPageChanged,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.all(16),
                child: GrowthChartContent(
                  config: subPages[i],
                  childName: profile.name,
                  accentColor: accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────
  double _ageInYears(DateTime date) =>
      date.difference(profile.birthDate).inDays / 365.25;

  double get _bmiLatest {
    final hm = latest.height / 100;
    return latest.weight / (hm * hm);
  }

  /// BB/U — berat badan terhadap usia (tahun)
  List<FlSpot> _spotsWeightForAge() => history.map((r) {
    final age = _ageInYears(r.date);
    return FlSpot(double.parse(age.toStringAsFixed(2)), r.weight);
  }).toList();

  /// BB vs TB — berat badan terhadap tinggi badan
  List<FlSpot> _spotsWeightForHeight() =>
      history.map((r) => FlSpot(r.height, r.weight)).toList();

  /// IMT/U — indeks massa tubuh terhadap usia (tahun)
  List<FlSpot> _spotsBmi() => history.map((r) {
    final age = _ageInYears(r.date);
    final hm = r.height / 100;
    final bmi = r.weight / (hm * hm);
    return FlSpot(
      double.parse(age.toStringAsFixed(2)),
      double.parse(bmi.toStringAsFixed(1)),
    );
  }).toList();
}
