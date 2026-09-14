import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/features/mother/growth/data/models/bb_sub_page_config.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/growth_record_entity.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/chart_card_common.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/growth_chart_content.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';

class ChartHeightCard extends StatelessWidget {
  final GrowthRecord latest;
  final ChildHeaderEntity profile;
  final List<GrowthRecord> history;
  final String childId;

  const ChartHeightCard({
    super.key,
    required this.latest,
    required this.profile,
    required this.history,
    required this.childId,
  });

  static const _accentColor = Color(0xFF00A735);

  @override
  Widget build(BuildContext context) {
    final cfg = BbSubPageConfig(
      title: 'Tinggi Badan Sesuai Usia',
      subtitle: '${latest.height.toInt()} cm / ${profile.age}',
      graficLabel: 'Grafik CDC',
      yAxisLabel: 'Tinggi (cm)',
      analysisType: 'height_for_age',
      childId: childId,
      spotsBuilder: _spotsHeight,
      rangeConfigs: const {
        ChartRange.zeroToTwoMonths: ChartAxisConfig(
          minX: 0,
          maxX: 60,
          intervalX: 10,
          minY: 35,
          maxY: 70,
          intervalY: 5,
          xAxisLabel: 'Usia (hari)',
          isMonths: false,
          xMultiplier: 30.0,
        ),
        ChartRange.zeroToTwelveMonths: ChartAxisConfig(
          minX: 1,
          maxX: 12,
          intervalX: 1,
          minY: 40,
          maxY: 90,
          intervalY: 10,
          xAxisLabel: 'Usia (bulan)',
          isMonths: true,
        ),
        ChartRange.zeroToFiveYears: ChartAxisConfig(
          minX: 0,
          maxX: 60,
          intervalX: 1,
          minY: 40,
          maxY: 130,
          intervalY: 10,
          xAxisLabel: 'Usia (bulan)',
          isMonths: true,
        ),
      },
    );

    return ChartCardShell(
      header: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
        child: ChartCardTitle(title: cfg.title, subtitle: cfg.subtitle),
      ),
      chartHeight: 390.h,
      chart: Padding(
        padding: EdgeInsets.all(16.w),
        child: GrowthChartContent(
          config: cfg,
          childName: profile.name,
          accentColor: _accentColor,
        ),
      ),
    );
  }

  /// TB/U — tinggi badan terhadap usia
  List<FlSpot> _spotsHeight(ChartRange range) => switch (range) {
    ChartRange.zeroToTwoMonths => const [
      FlSpot(0.0, 50.0),
      FlSpot(0.5, 52.5),
      FlSpot(1.0, 54.5),
      FlSpot(1.5, 56.2),
      FlSpot(2.0, 58.0),
    ],
    ChartRange.zeroToTwelveMonths => const [
      FlSpot(1, 54.5),
      FlSpot(2, 58.0),
      FlSpot(3, 61.0),
      FlSpot(5, 65.5),
      FlSpot(6, 67.5),
    ],
    ChartRange.zeroToFiveYears => const [
      FlSpot(12, 75.0),
      FlSpot(24, 87.0),
      FlSpot(36, 95.5),
      FlSpot(48, 102.0),
      FlSpot(60, 109.5),
    ],
  };
}
