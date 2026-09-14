import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/router.dart';

class NoteCard extends StatelessWidget {
  final String id;
  final String childName;
  final String date;
  final String desc;
  final int pantangan;
  final int alergi;
  final bool isActive;

  const NoteCard({
    super.key,
    required this.id,
    required this.childName,
    required this.date,
    required this.desc,
    required this.pantangan,
    required this.alergi,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoutes.noteDetail.name,
        pathParameters: {'id': id},
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: isActive ? null : Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
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
                  childName,
                  style: GoogleFonts.outfit(
                    color: Colors.black87,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFE8F5E9)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF00A735)
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            isActive ? 'Aktif' : 'Kadaluwarsa',
                            style: GoogleFonts.outfit(
                              color: isActive
                                  ? const Color(0xFF00A735)
                                  : Colors.grey,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black54,
                      size: 20.sp,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.access_time_filled,
                  color: Colors.black38,
                  size: 14.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  date,
                  style: GoogleFonts.outfit(
                    color: Colors.black54,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              desc,
              style: GoogleFonts.outfit(
                color: Colors.black54,
                fontSize: 12.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                _buildBadge(
                  icon: Icons.cancel,
                  text: '$pantangan pantangan',
                  color: const Color(0xFFF44336),
                  bgColor: const Color(0xFFFFEBEE),
                ),
                SizedBox(width: 12.w),
                _buildBadge(
                  icon: Icons.info,
                  text: '$alergi alergi',
                  color: const Color(0xFFFF9800),
                  bgColor: const Color(0xFFFFF3E0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String text,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            text,
            style: GoogleFonts.outfit(
              color: color,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
