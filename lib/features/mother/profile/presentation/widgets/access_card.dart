import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AccessCard extends StatelessWidget {
  final String name;
  final String role;
  final String location;
  final String? imageUrl;
  final IconData locationIcon;
  final bool isPlaceholderAvatar;
  final bool isActive;
  final List<Widget>? actions;
  final String? badgeText;

  const AccessCard({
    super.key,
    required this.name,
    required this.role,
    required this.location,
    this.imageUrl,
    this.locationIcon = Icons.local_hospital,
    this.isPlaceholderAvatar = false,
    required this.isActive,
    this.actions,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: isPlaceholderAvatar
                          ? (isActive ? Colors.orange[100] : Colors.grey[200])
                          : null,
                      borderRadius: BorderRadius.circular(12.r),
                      image: !isPlaceholderAvatar && imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: isPlaceholderAvatar
                        ? Icon(
                            Icons.person,
                            color: isActive ? Colors.orange : Colors.grey,
                            size: 30.sp,
                          )
                        : null,
                  ),
                  if (isActive)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF00A735)
                              : Colors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.w),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: GoogleFonts.outfit(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (badgeText != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFFDDEFDD)
                                  : const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              badgeText!,
                              style: GoogleFonts.outfit(
                                color: isActive
                                    ? const Color(0xFF00A735)
                                    : Colors.black54,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      role,
                      style: GoogleFonts.outfit(
                        color: Colors.black87,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(locationIcon, size: 14.sp, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text(
                          location,
                          style: GoogleFonts.outfit(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (actions != null) ...[
            SizedBox(height: 16.h),
            Row(children: actions!),
          ],
        ],
      ),
    );
  }
}
