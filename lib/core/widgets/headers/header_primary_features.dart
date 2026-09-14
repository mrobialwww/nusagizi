import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/core/utils/image_helper.dart';

class HeaderPrimaryFeatures extends StatelessWidget
    implements PreferredSizeWidget {
  final ChildHeaderEntity profile;
  final bool latest;
  final Color accentColor;
  final VoidCallback onPickerTapped;
  final List<Widget>? actions;

  const HeaderPrimaryFeatures({
    super.key,
    required this.profile,
    this.latest = false,
    this.accentColor = const Color(0xFF4CAF50),
    required this.onPickerTapped,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(75.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 16.w,
        right: 16.w,
        bottom: 12.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          context.canPop()
              ? Row(
                  children: [
                    const BackButton(color: Colors.black87),
                    SizedBox(width: 4.w),
                  ],
                )
              : const SizedBox.shrink(),

          // Profil Anak (Dapat diklik untuk membuka picker)
          Expanded(
            child: GestureDetector(
              onTap: onPickerTapped,
              child: Container(
                color: Colors.transparent, // Memperbesar area klik
                child: Row(
                  children: [
                    // Avatar
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor:
                            ImageHelper.getSafeImageProvider(
                                  profile.imagePath,
                                ) ==
                                null
                            ? ImageHelper.getAvatarColor(profile.name)
                            : accentColor.withValues(alpha: 0.2),
                        backgroundImage: ImageHelper.getSafeImageProvider(
                          profile.imagePath,
                        ),
                        child:
                            ImageHelper.getSafeImageProvider(
                                  profile.imagePath,
                                ) ==
                                null
                            ? Text(
                                ImageHelper.getInitials(profile.name),
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Nama dan Umur
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            profile.name,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            profile.age,
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (actions != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!.asMap().entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(left: entry.key == 0 ? 0 : 8.w),
                  child: entry.value,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
