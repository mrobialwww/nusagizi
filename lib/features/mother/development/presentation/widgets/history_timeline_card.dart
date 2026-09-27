import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryTimelineCard extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String date;
  final String monthTitle;
  final int kpspScore;
  final String status;

  const HistoryTimelineCard({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.date,
    required this.monthTitle,
    required this.kpspScore,
    required this.status,
  });

  static const Color _green = Color(0xFF00A735);

  Color _statusColor() {
    if (status == 'Sesuai Usia') return _green;
    if (status == 'Perkembangan meragukan') return Colors.orange;
    return Colors.red;
  }

  String _summaryTitle() {
    final s = status.toLowerCase();
    if (s.contains('sesuai usia')) return 'Perkembangan Sangat Baik';
    if (s.contains('meragukan')) return 'Perkembangan Meragukan';
    return 'Perkembangan Menyimpang';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 24,
                    color: const Color(0xFFE0E0E0),
                  )
                else
                  SizedBox(height: 24.h),

                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDEFDD),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.checklist_rtl_rounded,
                    size: 16.sp,
                    color: _green,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: const Color(0xFFE0E0E0)),
                  ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDDEFDD),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            'Hasil KPSP',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.w700,
                              fontSize: 10.sp,
                              color: _green,
                            ),
                          ),
                        ),
                        Text(
                          date,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      monthTitle,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // ── KPSP score + status row ──
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: statusColor, width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$kpspScore',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                              color: statusColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                status,
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                  color: statusColor,
                                ),
                              ),
                              Text(
                                _summaryTitle(),
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
