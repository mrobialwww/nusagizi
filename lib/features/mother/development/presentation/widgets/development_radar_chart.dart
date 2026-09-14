import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DevelopmentRadarChart extends StatelessWidget {
  final double motorikHalus;
  final double motorikKasar;
  final double sosialisasi;
  final double bicara;
  final Color color;
  final double height;
  final int tickCount;
  final double borderWidth;
  final Color radarBorderColor;
  final Color gridBorderColor;
  final TextStyle? titleTextStyle;
  final double titlePositionPercentageOffset;

  const DevelopmentRadarChart({
    super.key,
    required this.motorikHalus,
    required this.motorikKasar,
    required this.sosialisasi,
    required this.bicara,
    required this.color,
    this.height = 200,
    this.tickCount = 3,
    this.borderWidth = 2,
    this.radarBorderColor = const Color(0xFFE0E0E0),
    this.gridBorderColor = const Color(0xFFE0E0E0),
    this.titleTextStyle,
    this.titlePositionPercentageOffset = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RadarChart(
        _radarData(),
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      ),
    );
  }

  RadarChartData _radarData() {
    return RadarChartData(
      dataSets: [
        RadarDataSet(
          fillColor: color.withValues(alpha: 0.15),
          borderColor: color,
          entryRadius: 3,
          dataEntries: [
            RadarEntry(value: motorikHalus),
            RadarEntry(value: motorikKasar),
            RadarEntry(value: sosialisasi),
            RadarEntry(value: bicara),
          ],
          borderWidth: borderWidth,
        ),
      ],
      radarBackgroundColor: Colors.transparent,
      borderData: FlBorderData(show: false),
      radarBorderData: BorderSide(color: radarBorderColor),
      titlePositionPercentageOffset: titlePositionPercentageOffset,
      titleTextStyle:
          titleTextStyle ??
          GoogleFonts.outfit(
            color: Colors.black87,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
      getTitle: (index, angle) => switch (index) {
        0 => const RadarChartTitle(text: 'Motorik\nHalus'),
        1 => const RadarChartTitle(text: 'Motorik\nKasar'),
        2 => const RadarChartTitle(text: 'Sosialisasi &\nKemandirian'),
        3 => const RadarChartTitle(text: 'Bicara &\nBahasa'),
        _ => const RadarChartTitle(text: ''),
      },
      tickCount: tickCount,
      ticksTextStyle: TextStyle(color: Colors.transparent, fontSize: 0.sp),
      tickBorderData: BorderSide(color: gridBorderColor),
      gridBorderData: BorderSide(color: gridBorderColor),
    );
  }
}
