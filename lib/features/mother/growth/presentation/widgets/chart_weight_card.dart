import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/features/mother/growth/data/models/bb_sub_page_config.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/growth_record_entity.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/chart_card_common.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/growth_chart_content.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';

class ChartWeightCard extends StatelessWidget {
  final Color accentColor;
  final GrowthRecord latest;
  final ChildHeaderEntity profile;
  final List<GrowthRecord> history;

  final int bbSubPage;
  final PageController bbPageController;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final String childId;

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
    required this.childId,
  });

  static const _subPageCount = 3;

  @override
  Widget build(BuildContext context) {
    final subPages = _buildSubPages();
    final cfg = subPages[bbSubPage];

    return ChartCardShell(
      header: Column(
        children: [
          // Judul & chevron navigasi sub-halaman
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 0),
            child: Row(
              children: [
                Visibility(
                  visible: bbSubPage > 0,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: GestureDetector(
                    onTap: onPrev,
                    child: Icon(
                      Icons.chevron_left,
                      size: 20.sp,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(
                  child: ChartCardTitle(
                    title: cfg.title,
                    subtitle: cfg.subtitle,
                  ),
                ),
                Visibility(
                  visible: bbSubPage < _subPageCount - 1,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: GestureDetector(
                    onTap: onNext,
                    child: Icon(
                      Icons.chevron_right,
                      size: 20.sp,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Dot indicator sub-halaman
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_subPageCount, (i) {
              final isActive = i == bbSubPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: isActive ? 20.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isActive
                      ? accentColor
                      : Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              );
            }),
          ),
        ],
      ),
      chartHeight: 376.h,
      // PageView grafik (arrow-only navigation)
      chart: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: bbPageController,
        itemCount: _subPageCount,
        onPageChanged: onPageChanged,
        itemBuilder: (_, i) => Padding(
          padding: EdgeInsets.all(16.w),
          child: GrowthChartContent(
            config: subPages[i],
            childName: profile.name,
            accentColor: accentColor,
          ),
        ),
      ),
    );
  }

  List<BbSubPageConfig> _buildSubPages() => [
    BbSubPageConfig(
      title: 'Berat Badan Sesuai Usia',
      subtitle: '${latest.weight} kg / ${profile.age}',
      graficLabel: 'Grafik CDC',
      yAxisLabel: 'Berat(kg)',
      analysisType: 'weight_for_age',
      childId: childId,
      spotsBuilder: _spotsWeightForAge,
      rangeConfigs: const {
        ChartRange.zeroToTwoMonths: ChartAxisConfig(
          minX: 0,
          maxX: 60,
          intervalX: 10,
          minY: 1,
          maxY: 10,
          intervalY: 1,
          xAxisLabel: 'Usia (hari)',
          isMonths: false,
          xMultiplier: 30.0,
        ),
        ChartRange.zeroToTwelveMonths: ChartAxisConfig(
          minX: 1,
          maxX: 12,
          intervalX: 1,
          minY: 2,
          maxY: 14,
          intervalY: 2,
          xAxisLabel: 'Usia (bulan)',
          isMonths: true,
        ),
        ChartRange.zeroToFiveYears: ChartAxisConfig(
          minX: 0,
          maxX: 60,
          intervalX: 1,
          minY: 5,
          maxY: 30,
          intervalY: 5,
          xAxisLabel: 'Usia (bulan)',
          isMonths: true,
        ),
      },
    ),
    BbSubPageConfig(
      title: 'Berat Badan vs Tinggi Badan',
      subtitle: '${latest.weight} kg / ${latest.height.toInt()} cm',
      graficLabel: 'Grafik WHO',
      yAxisLabel: 'Berat(kg)',
      analysisType: 'weight_for_height',
      childId: childId,
      singleSpots: _spotsWeightForHeight(),
      hasAgeDropdown: false,
      singleConfig: const ChartAxisConfig(
        minX: 50,
        maxX: 105,
        intervalX: 5,
        minY: 0,
        maxY: 30,
        intervalY: 5,
        xAxisLabel: 'Tinggi (cm)',
      ),
    ),
    BbSubPageConfig(
      title: 'Indeks Massa Tubuh Sesuai Usia',
      subtitle: '${_bmiLatest.toStringAsFixed(1)} kg/m² / ${profile.age}',
      graficLabel: 'Grafik WHO',
      yAxisLabel: 'IMT(kg/m²)',
      analysisType: 'bmi_for_age',
      childId: childId,
      spotsBuilder: _spotsBmi,
      rangeConfigs: const {
        ChartRange.zeroToTwoMonths: ChartAxisConfig(
          minX: 0,
          maxX: 60,
          intervalX: 10,
          minY: 10,
          maxY: 24,
          intervalY: 2,
          xAxisLabel: 'Usia (hari)',
          isMonths: false,
          xMultiplier: 30.0,
        ),
        ChartRange.zeroToTwelveMonths: ChartAxisConfig(
          minX: 1,
          maxX: 12,
          intervalX: 1,
          minY: 10,
          maxY: 24,
          intervalY: 2,
          xAxisLabel: 'Usia (bulan)',
          isMonths: true,
        ),
        ChartRange.zeroToFiveYears: ChartAxisConfig(
          minX: 0,
          maxX: 60,
          intervalX: 1,
          minY: 10,
          maxY: 24,
          intervalY: 2,
          xAxisLabel: 'Usia (bulan)',
          isMonths: true,
        ),
      },
    ),
  ];

  // ─── Helpers ──────────────────────────────────────────────────────────────

  double get _bmiLatest {
    final heightInMeters = latest.height / 100;
    return latest.weight / (heightInMeters * heightInMeters);
  }

  /// BB/U — berat badan terhadap usia
  List<FlSpot> _spotsWeightForAge(ChartRange range) => switch (range) {
    ChartRange.zeroToTwoMonths => const [
      FlSpot(0.0, 3.2),
      FlSpot(0.5, 3.8),
      FlSpot(1.0, 4.5),
      FlSpot(1.5, 5.1),
      FlSpot(2.0, 5.5),
    ],
    ChartRange.zeroToTwelveMonths => const [
      FlSpot(1, 4.5),
      FlSpot(2, 5.5),
      FlSpot(3, 6.2),
      FlSpot(5, 7.5),
      FlSpot(6, 8.1),
    ],
    ChartRange.zeroToFiveYears => const [
      FlSpot(12, 9.5),
      FlSpot(24, 12.0),
      FlSpot(36, 14.5),
      FlSpot(48, 16.5),
      FlSpot(60, 18.0),
    ],
  };

  /// BB/TB — berat badan terhadap tinggi badan (cm)
  List<FlSpot> _spotsWeightForHeight() => const [
    FlSpot(50.0, 3.2),
    FlSpot(52.5, 3.8),
    FlSpot(54.5, 4.5),
    FlSpot(56.2, 5.1),
    FlSpot(58.0, 5.5),
  ];

  /// IMT/U — indeks massa tubuh terhadap usia
  List<FlSpot> _spotsBmi(ChartRange range) => switch (range) {
    ChartRange.zeroToTwoMonths => const [
      FlSpot(0.0, 12.8),
      FlSpot(0.5, 13.7),
      FlSpot(1.0, 15.1),
      FlSpot(1.5, 15.8),
      FlSpot(2.0, 16.3),
    ],
    ChartRange.zeroToTwelveMonths => const [
      FlSpot(1, 15.1),
      FlSpot(2, 16.3),
      FlSpot(3, 16.8),
      FlSpot(5, 17.5),
      FlSpot(6, 17.7),
    ],
    ChartRange.zeroToFiveYears => const [
      FlSpot(12, 16.8),
      FlSpot(24, 15.8),
      FlSpot(36, 15.5),
      FlSpot(48, 15.3),
      FlSpot(60, 15.0),
    ],
  };
}
