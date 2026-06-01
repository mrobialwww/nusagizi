import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/features/mother/growth/presentation/models/bb_sub_page_config.dart';

enum ChartRange {
  zeroToTwoMonths,
  zeroToTwelveMonths,
  zeroToFiveYears,
  fiveToEighteenYears,
}

extension ChartRangeExt on ChartRange {
  String get label {
    switch (this) {
      case ChartRange.zeroToTwoMonths:
        return 'Grafik 0 - 2 Bulan';
      case ChartRange.zeroToTwelveMonths:
        return 'Grafik 0 - 12 Bulan';
      case ChartRange.zeroToFiveYears:
        return 'Grafik 0 - 5 Tahun';
      case ChartRange.fiveToEighteenYears:
        return 'Grafik 5 - 18 Tahun';
    }
  }
}

class GrowthChartContent extends StatefulWidget {
  final BbSubPageConfig config;
  final String childName;
  final Color accentColor;

  const GrowthChartContent({
    super.key,
    required this.config,
    required this.childName,
    required this.accentColor,
  });

  @override
  State<GrowthChartContent> createState() => _GrowthChartContentState();
}

class _GrowthChartContentState extends State<GrowthChartContent> {
  ChartRange _chartRange = ChartRange.zeroToFiveYears;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.config.graficLabel,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  widget.config.yAxisLabel,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
            _rangeDropdown(),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(height: 180, child: LineChart(_lineChartData(widget.config))),
        const SizedBox(height: 8),
        _chartLegend(widget.config.xAxisLabel),
      ],
    );
  }

  // ─── Range Dropdown ────────────────────────────────────────────────────────

  Widget _rangeDropdown() {
    return GestureDetector(
      onTap: _showRangePicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _chartRange.label,
              style: GoogleFonts.outfit(fontSize: 11, color: Colors.black54),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  void _showRangePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Tampilan Grafik',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ...ChartRange.values.map((range) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        range.label,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _chartRange = range;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    if (range != ChartRange.values.last)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF0F0F0),
                      ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _chartLegend(String xLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 22, height: 3, color: widget.accentColor),
            const SizedBox(width: 6),
            Text(
              'Pertumbuhan ${widget.childName.split(' ').last}',
              style: GoogleFonts.outfit(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
        Text(
          xLabel,
          style: GoogleFonts.outfit(fontSize: 11, color: Colors.black45),
        ),
      ],
    );
  }

  // ─── Chart Data Builders ───────────────────────────────────────────────────

  LineChartData _lineChartData(BbSubPageConfig cfg) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: Colors.grey.withOpacity(0.15), strokeWidth: 1),
        getDrawingVerticalLine: (_) =>
            FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: (cfg.maxY - cfg.minY) / 5,
            getTitlesWidget: (v, _) => Text(
              v.toInt().toString(),
              style: const TextStyle(fontSize: 9, color: Colors.black45),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: cfg.isMonths ? 6 : (cfg.maxX > 10 ? 10 : 0.5),
            getTitlesWidget: (v, _) => Text(
              cfg.isMonths ? v.toInt().toString() : v.toStringAsFixed(1),
              style: const TextStyle(fontSize: 9, color: Colors.black45),
            ),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      minX: cfg.minX,
      maxX: cfg.maxX,
      minY: cfg.minY,
      maxY: cfg.maxY,
      lineBarsData: [
        LineChartBarData(
          spots: cfg.spots,
          isCurved: true,
          color: widget.accentColor,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
              radius: 3,
              color: Colors.white,
              strokeColor: widget.accentColor,
              strokeWidth: 2,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: widget.accentColor.withOpacity(0.08),
          ),
        ),
      ],
    );
  }
}
