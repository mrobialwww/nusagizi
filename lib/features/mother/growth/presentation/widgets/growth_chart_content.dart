import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/growth/data/models/bb_sub_page_config.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_analyses_cubit.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_analyses_state.dart';

enum ChartRange { zeroToTwoMonths, zeroToTwelveMonths, zeroToFiveYears }

extension ChartRangeExt on ChartRange {
  String get label => switch (this) {
    ChartRange.zeroToTwoMonths => 'Grafik 0 - 2 Bulan',
    ChartRange.zeroToTwelveMonths => 'Grafik 0 - 12 Bulan',
    ChartRange.zeroToFiveYears => 'Grafik 0 - 5 Tahun',
  };
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

  String _toAgeRange(ChartRange range) => switch (range) {
    ChartRange.zeroToTwoMonths => '0-2',
    ChartRange.zeroToTwelveMonths => '0-12',
    ChartRange.zeroToFiveYears => '0-60',
  };

  ChartAxisConfig get _activeConfig => widget.config.hasAgeDropdown
      ? (widget.config.rangeConfigs?[_chartRange] ??
            widget.config.rangeConfigs!.values.first)
      : widget.config.singleConfig!;

  @override
  Widget build(BuildContext context) {
    final cfg = _activeConfig;

    return LayoutBuilder(
      builder: (context, constraints) {
        final numXCells = ((cfg.maxX - cfg.minX) / cfg.intervalX) + 1;
        final numYCells = ((cfg.maxY - cfg.minY) / cfg.intervalY) + 1;

        // ── Konstanta layout ──
        final leftReserved = 40.0.w; // lebar area label Y (kiri)
        final rightReserved = 16.0.w; // ruang napas label maxX
        final topReserved = 14.0.h; // ruang napas label maxY
        final bottomReserved = 34.0.h; // tinggi area label X

        // ── Tinggi chart ──
        final double chartHeight;
        if (constraints.maxHeight.isFinite && constraints.maxHeight > 0) {
          chartHeight = constraints.maxHeight;
        } else {
          chartHeight = 300.0;
        }

        // Jarak antar titik Y (agar X dan Y seimbang)
        final cellPxY =
            (chartHeight - topReserved - bottomReserved) / numYCells;

        // Jarak antar titik X disamakan dengan Y (persegi)
        final cellPxX = cellPxY;

        final calculatedChartWidth =
            (numXCells * cellPxX) + leftReserved + rightReserved;

        // ── Lebar chart ──
        final chartWidth = calculatedChartWidth > constraints.maxWidth
            ? calculatedChartWidth
            : constraints.maxWidth;

        Widget buildChartWidget(
          List<FlSpot>? apiSpots,
          bool isLoading,
          String? errorMsg,
        ) {
          if (errorMsg != null) {
            return SizedBox(
              height: chartHeight,
              width: chartWidth,
              child: Center(child: Text(errorMsg)),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: chartHeight,
              width: chartWidth,
              child: LineChart(
                _mainData(
                  cfg,
                  leftReserved,
                  bottomReserved,
                  topReserved,
                  rightReserved,
                  apiSpots,
                ),
              ),
            ),
          );
        }

        if (widget.config.analysisType != null &&
            widget.config.childId != null) {
          return BlocBuilder<GrowthAnalysesCubit, GrowthAnalysesState>(
            builder: (context, analysesState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  context.read<GrowthAnalysesCubit>().fetch(
                    childId: widget.config.childId!,
                    analysisType: widget.config.analysisType!,
                    ageRange: widget.config.hasAgeDropdown
                        ? _toAgeRange(_chartRange)
                        : '0-60',
                  );
                }
              });

              if (analysesState is GrowthAnalysesLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00A735)),
                );
              }

              List<FlSpot>? apiSpots;
              String? errorMsg;

              if (analysesState is GrowthAnalysesLoaded) {
                apiSpots = analysesState.data.dataPoints
                    .map((p) => FlSpot(p.x, p.y))
                    .toList();
              } else if (analysesState is GrowthAnalysesError) {
                errorMsg = analysesState.message;
              }

              final chartWidget = buildChartWidget(apiSpots, false, errorMsg);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.config.graficLabel,
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              widget.config.yAxisLabel,
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.config.hasAgeDropdown) _rangeDropdown(),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  if (constraints.maxHeight.isFinite &&
                      constraints.maxHeight > 0)
                    Expanded(child: chartWidget)
                  else
                    chartWidget,
                  SizedBox(height: 8.h),
                  _chartLegend(cfg.xAxisLabel),
                ],
              );
            },
          );
        }

        final chartWidget = buildChartWidget(null, false, null);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.config.graficLabel,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        widget.config.yAxisLabel,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.config.hasAgeDropdown) _rangeDropdown(),
              ],
            ),
            SizedBox(height: 12.h),
            if (constraints.maxHeight.isFinite && constraints.maxHeight > 0)
              Expanded(child: chartWidget)
            else
              chartWidget,
            SizedBox(height: 8.h),
            _chartLegend(cfg.xAxisLabel),
          ],
        );
      },
    );
  }

  // ─── Range Dropdown ────────────────────────────────────────────────────────

  Widget _rangeDropdown() {
    return GestureDetector(
      onTap: _showRangePicker,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _chartRange.label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
                color: Colors.black54,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.keyboard_arrow_down, size: 14.sp, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  void _showRangePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Text(
                'Tampilan Grafik',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.h),
              ...ChartRange.values.map((range) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        range.label,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                      onTap: () {
                        setState(() => _chartRange = range);
                        if (widget.config.analysisType != null &&
                            widget.config.childId != null) {
                          context.read<GrowthAnalysesCubit>().fetch(
                            childId: widget.config.childId!,
                            analysisType: widget.config.analysisType!,
                            ageRange: _toAgeRange(range),
                          );
                        }
                        context.pop();
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
            Container(width: 22.w, height: 3.h, color: widget.accentColor),
            SizedBox(width: 6.w),
            Text(
              'Pertumbuhan ${widget.childName.split(' ').last}',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        Text(
          xLabel,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }

  // ─── Chart Data (mengikuti pola resmi fl_chart: lihat line_chart_sample2) ──

  List<FlSpot> _getSpots(ChartAxisConfig cfg, List<FlSpot>? apiSpots) {
    var raw =
        apiSpots ??
        (widget.config.hasAgeDropdown
            ? widget.config.spotsBuilder!(_chartRange)
            : widget.config.singleSpots!);

    if (cfg.xMultiplier != 1.0) {
      raw = raw.map((s) => FlSpot(s.x * cfg.xMultiplier, s.y)).toList();
    }

    return raw.where((s) => s.x >= cfg.minX && s.x <= cfg.maxX).toList();
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta, ChartAxisConfig cfg) {
    if (value < cfg.minY || value > cfg.maxY) return const SizedBox.shrink();
    return SideTitleWidget(
      meta: meta,
      child: Text(
        value.toInt().toString(),
        style: TextStyle(fontSize: 11.sp, color: Colors.black54),
      ),
    );
  }

  Widget _bottomTitleWidgets(
    double value,
    TitleMeta meta,
    ChartAxisConfig cfg,
  ) {
    if (value < cfg.minX || value > cfg.maxX) return const SizedBox.shrink();
    return SideTitleWidget(
      meta: meta,
      child: Text(
        cfg.isMonths ? value.toInt().toString() : value.toStringAsFixed(0),
        style: TextStyle(fontSize: 11.sp, color: Colors.black54),
      ),
    );
  }

  LineChartData _mainData(
    ChartAxisConfig cfg,
    double leftReserved,
    double bottomReserved,
    double topReserved,
    double rightReserved,
    List<FlSpot>? apiSpots,
  ) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        horizontalInterval: cfg.intervalY > 0 ? cfg.intervalY : 1,
        verticalInterval: cfg.intervalX > 0 ? cfg.intervalX : 1,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey.withValues(alpha: 0.15), strokeWidth: 1),
        getDrawingVerticalLine: (value) =>
            FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: leftReserved,
            interval: cfg.intervalY > 0 ? cfg.intervalY : 1,
            getTitlesWidget: (value, meta) =>
                _leftTitleWidgets(value, meta, cfg),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: bottomReserved,
            interval: cfg.intervalX > 0 ? cfg.intervalX : 1,
            getTitlesWidget: (value, meta) =>
                _bottomTitleWidgets(value, meta, cfg),
          ),
        ),
        // showTitles tetap true (bukan false) agar reservedSize tetap
        // menyediakan ruang napas di tepi chart, walau tanpa label.
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: topReserved,
            getTitlesWidget: (_, __) => const SizedBox.shrink(),
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: rightReserved,
            getTitlesWidget: (_, __) => const SizedBox.shrink(),
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      minX: cfg.minX - cfg.intervalX,
      maxX: cfg.maxX,
      minY: cfg.minY - cfg.intervalY,
      maxY: cfg.maxY,
      lineBarsData: [
        LineChartBarData(
          spots: _getSpots(cfg, apiSpots),
          isCurved: true,
          curveSmoothness: 0.1,
          preventCurveOverShooting: true,
          color: widget.accentColor,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: widget.accentColor.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}
