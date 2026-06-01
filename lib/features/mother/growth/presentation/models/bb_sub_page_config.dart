import 'package:fl_chart/fl_chart.dart';

class BbSubPageConfig {
  final String title;
  final String subtitle;
  final String graficLabel;
  final String yAxisLabel;
  final String xAxisLabel;
  final List<FlSpot> spots;
  final double minX, maxX, minY, maxY;
  final bool isMonths;

  const BbSubPageConfig({
    required this.title,
    required this.subtitle,
    required this.graficLabel,
    required this.yAxisLabel,
    required this.xAxisLabel,
    required this.spots,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.isMonths,
  });
}
