import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_summary_entity.dart';
import 'package:nusagizi/core/widgets/status_badge.dart';
import 'package:nusagizi/core/utils/image_helper.dart';

class FrontChildCard extends StatelessWidget {
  final ChildSummaryEntity childData;
  final VoidCallback onFlip;

  const FrontChildCard({
    super.key,
    required this.childData,
    required this.onFlip,
  });

  @override
  Widget build(BuildContext context) {
    final safeImage = ImageHelper.getSafeImageProvider(childData.imagePath);

    return GestureDetector(
      onTap: onFlip,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: safeImage == null
              ? ImageHelper.getAvatarColor(childData.name)
              : null,
          borderRadius: BorderRadius.circular(32.r),
          image: safeImage != null
              ? DecorationImage(image: safeImage, fit: BoxFit.cover)
              : null,
        ),
        child: Stack(
          children: [
            if (safeImage == null)
              Center(
                child: Text(
                  ImageHelper.getInitials(childData.name),
                  style: GoogleFonts.outfit(
                    fontSize: 120.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            // Gradient for bottom text
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32.r),
                    bottomRight: Radius.circular(32.r),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Streak
            Positioned(
              top: 16.h,
              left: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 20.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${childData.streak}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Flip button
            Positioned(
              top: 16.h,
              right: 16.w,
              child: GestureDetector(
                onTap: onFlip,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.replay, color: Colors.white, size: 24.sp),
                ),
              ),
            ),
            // Info bottom
            Positioned(
              bottom: 24.h,
              left: 20.w,
              right: 20.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tag
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: StatusBadge.getColorForStatus(
                              childData.statusTag,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                childData.statusTag,
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          childData.name,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          childData.age,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // QR icon
                  Image.asset(
                    AppImages.qr,
                    width: 56.w,
                    height: 56.w,
                    color: Colors.white,
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
