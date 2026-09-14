import 'package:fl_chart/fl_chart.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/growth_chart_content.dart'
    show ChartRange;

class ChartAxisConfig {
  final double minX;
  final double maxX;
  final double intervalX;
  final double minY;
  final double maxY;
  final double intervalY;
  final String xAxisLabel;
  final bool isMonths;
  final double xMultiplier;

  const ChartAxisConfig({
    required this.minX,
    required this.maxX,
    required this.intervalX,
    required this.minY,
    required this.maxY,
    required this.intervalY,
    required this.xAxisLabel,
    this.isMonths = false,
    this.xMultiplier = 1.0,
  });
}

typedef SpotsBuilder = List<FlSpot> Function(ChartRange range);

class BbSubPageConfig {
  final String title;
  final String subtitle;
  final String graficLabel;
  final String yAxisLabel;
  final SpotsBuilder? spotsBuilder;
  final List<FlSpot>? singleSpots;
  final bool hasAgeDropdown;
  final Map<ChartRange, ChartAxisConfig>? rangeConfigs;
  final ChartAxisConfig? singleConfig;
  final String? analysisType;
  final String? childId;

  const BbSubPageConfig({
    required this.title,
    required this.subtitle,
    required this.graficLabel,
    required this.yAxisLabel,
    this.spotsBuilder,
    this.singleSpots,
    this.hasAgeDropdown = true,
    this.rangeConfigs,
    this.singleConfig,
    this.analysisType,
    this.childId,
  }) : assert(
         (hasAgeDropdown && rangeConfigs != null && spotsBuilder != null) ||
             (!hasAgeDropdown && singleConfig != null && singleSpots != null),
         'Must provide rangeConfigs and spotsBuilder if hasAgeDropdown is true, or singleConfig and singleSpots if false',
       );
}
