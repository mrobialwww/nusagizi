import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/widgets/status_badge.dart';

class DevelopmentSummaryCard extends StatelessWidget {
  const DevelopmentSummaryCard({
    super.key,
    required this.badgeStatus,
    required this.lastCheck,
    required this.kpspScore,
    required this.nextCheck,
  });

  final String badgeStatus;
  final String lastCheck;
  final String kpspScore;
  final String nextCheck;

  static const Color _tileBackgroundColor = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleAndLastCheck(),
              StatusBadge(status: badgeStatus),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.assignment_turned_in,
                  label: 'Skor KPSP',
                  value: kpspScore,
                  valueFontSize: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.calendar_today,
                  label: 'Cek berikutnya:',
                  value: nextCheck,
                  valueFontSize: 16.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAndLastCheck() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan\nPerkembangan',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            color: Colors.black87,
            height: 1.2,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Terakhir dicek: $lastCheck',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
    required double valueFontSize,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: _tileBackgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.sp, color: Colors.black54),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w700,
                  fontSize: valueFontSize,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
