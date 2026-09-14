import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum HistoryType { checklist, kpsp }

class HistoryTimelineCard extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final HistoryType type;
  final String date;
  final String monthTitle;
  final Widget contentWidget;

  const HistoryTimelineCard({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.type,
    required this.date,
    required this.monthTitle,
    required this.contentWidget,
  });

  static const Color _green = Color(0xFF00A735);
  static const Color _orange = Color(0xFFF26E22);

  @override
  Widget build(BuildContext context) {
    final bool isChecklist = type == HistoryType.checklist;
    final Color iconColor = isChecklist ? _orange : _green;
    final Color iconBgColor = isChecklist
        ? const Color(0xFFFFE5D9)
        : const Color(0xFFDDEFDD);
    final String tagText = isChecklist ? 'Update Checklist' : 'Hasil KPSP';

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
                    color: iconBgColor,
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
                    isChecklist
                        ? Icons.fact_check_rounded
                        : Icons.checklist_rtl_rounded,
                    size: 16.sp,
                    color: iconColor,
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            tagText,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                              color: iconColor,
                            ),
                          ),
                        ),
                        Text(
                          date,
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      monthTitle,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    contentWidget,
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