import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/widgets/app_card.dart';

/// Title + subtitle text block shared by every growth chart card header.
class ChartCardTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const ChartCardTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w400,
            fontSize: 11.sp,
            color: Colors.black45,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Common [AppCard] shell (header + divider + chart area) shared by every
/// growth chart card, so the three chart widgets don't repeat the same
/// layout scaffolding.
class ChartCardShell extends StatelessWidget {
  final Widget header;
  final double chartHeight;
  final Widget chart;

  const ChartCardShell({
    super.key,
    required this.header,
    required this.chartHeight,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          header,
          SizedBox(height: 12.h),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          SizedBox(height: chartHeight, child: chart),
        ],
      ),
    );
  }
}
