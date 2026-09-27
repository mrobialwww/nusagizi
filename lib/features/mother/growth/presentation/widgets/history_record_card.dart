import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/widgets/status_badge.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/latest_growth_report_entity.dart';

class HistoryRecordCard extends StatelessWidget {
  final LatestGrowthReportEntity record;
  final String Function(DateTime) formatDate;

  const HistoryRecordCard({
    super.key,
    required this.record,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final isWarning = record.status.toLowerCase() != 'normal';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
            children: [
              Text(
                formatDate(record.measuredAt),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
              StatusBadge(status: record.status),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _infoBox(
                'Berat',
                '${record.weightKg ?? "-"}',
                'kg',
                Icons.monitor_weight_outlined,
              ),
              SizedBox(width: 8.w),
              _infoBox(
                'Tinggi',
                '${record.heightCm?.toInt() ?? "-"}',
                'cm',
                Icons.height,
              ),
              SizedBox(width: 8.w),
              _infoBox(
                'L.Kepala',
                '${record.headCircumferenceCm?.toInt() ?? "-"}',
                'cm',
                Icons.face_outlined,
              ),
            ],
          ),
          if (isWarning) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEAEA),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 16.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      record.description,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp,
                        color: Colors.red,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoBox(String title, String value, String unit, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 12.sp, color: Colors.black54),
                SizedBox(width: 4.w),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 11.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
