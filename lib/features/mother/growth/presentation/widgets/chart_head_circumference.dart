import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/features/mother/growth/data/models/bb_sub_page_config.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/growth_record_entity.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/chart_card_common.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/growth_chart_content.dart';

class ChartHeadCircumference extends StatelessWidget {
  final GrowthRecord latest;
  final ChildHeaderEntity profile;
  final List<GrowthRecord> history;
  final String childId;

  const ChartHeadCircumference({
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
      title: 'Lingkar Kepala Sesuai Usia',
      subtitle: '${latest.headCircumference.toInt()} cm / ${profile.age}',
      graficLabel: 'Grafik WHO',
      yAxisLabel: 'L.Kepala(cm)',
      analysisType: 'head_circumference_for_age',
      childId: childId,
      spotsBuilder: _spotsHeadCirc,
      rangeConfigs: const {
        ChartRange.zeroToTwoMonths: ChartAxisConfig(
          minX: 0,
          maxX: 60,
          intervalX: 10,
          minY: 25,
          maxY: 45,
          intervalY: 5,
          xAxisLabel: 'Usia (hari)',
          isMonths: false,
          xMultiplier: 30.0,
        ),
        ChartRange.zeroToTwelveMonths: ChartAxisConfig(
          minX: 1,
          maxX: 12,
          intervalX: 1,
          minY: 25,
          maxY: 55,
          intervalY: 5,
          xAxisLabel: 'Usia (bulan)',
          isMonths: true,
        ),
        ChartRange.zeroToFiveYears: ChartAxisConfig(
          minX: 0,
          maxX: 60,
          intervalX: 1,
          minY: 30,
          maxY: 70,
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

  /// LK/U — lingkar kepala terhadap usia
  List<FlSpot> _spotsHeadCirc(ChartRange range) => switch (range) {
    ChartRange.zeroToTwoMonths => const [
      FlSpot(0.0, 34.5),
      FlSpot(0.5, 36.0),
      FlSpot(1.0, 37.0),
      FlSpot(1.5, 37.8),
      FlSpot(2.0, 38.5),
    ],
    ChartRange.zeroToTwelveMonths => const [
      FlSpot(1, 37.0),
      FlSpot(2, 38.5),
      FlSpot(3, 39.8),
      FlSpot(5, 41.8),
      FlSpot(6, 42.5),
    ],
    ChartRange.zeroToFiveYears => const [
      FlSpot(12, 46.0),
      FlSpot(24, 48.2),
      FlSpot(36, 49.5),
      FlSpot(48, 50.5),
      FlSpot(60, 51.0),
    ],
  };
}
