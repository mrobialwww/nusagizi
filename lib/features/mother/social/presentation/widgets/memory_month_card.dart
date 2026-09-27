import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:nusagizi/features/mother/social/domain/entities/child_photo_entity.dart';
import 'package:nusagizi/router.dart';

import 'package:intl/intl.dart';

class MemoryMonthCard extends StatelessWidget {
  final DateTime monthDate;
  final List<ChildPhotoEntity> photos;

  const MemoryMonthCard({
    super.key,
    required this.monthDate,
    this.photos = const [],
  });

  @override
  Widget build(BuildContext context) {
    final monthYearStr = DateFormat('MMMM yyyy', 'id_ID').format(monthDate);
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final firstDayWeekday = DateTime(
      monthDate.year,
      monthDate.month,
      1,
    ).weekday; // 1 = Monday, 7 = Sunday

    // Calendar math: offset for start day matching Monday as start of week.
    final startOffset = firstDayWeekday - 1;
    final totalCells = startOffset + daysInMonth;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3D3D3D), // Dark grey
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Month Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFF6B6B6B), // Lighter grey header
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Text(
              monthYearStr,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Grid
          Padding(
            padding: EdgeInsets.all(16.w),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 7 columns with 8 spacing between them
                final double itemWidth = (constraints.maxWidth - (6 * 8.w)) / 7;

                return Wrap(
                  spacing: 8.w,
                  runSpacing: 8.w,
                  children: List.generate(totalCells, (index) {
                    // Empty cells before the 1st of the month
                    if (index < startOffset) {
                      return SizedBox(width: itemWidth, height: itemWidth);
                    }

                    final dayNumber = index - startOffset + 1;
                    final cellDate = DateTime(
                      monthDate.year,
                      monthDate.month,
                      dayNumber,
                    );
                    final now = DateTime.now();
                    final nowMidnight = DateTime(now.year, now.month, now.day);
                    final isPastOrToday = !cellDate.isAfter(nowMidnight);

                    ChildPhotoEntity? photo;
                    for (var p in photos) {
                      final dt = p.createdAt?.toLocal();
                      if (dt != null && dt.day == dayNumber) {
                        photo = p; // Langsung ambil yang pertama kali cocok
                        break;
                      }
                    }
                    Widget content = const SizedBox();
                    Color cellColor = Colors.transparent;

                    if (photo != null) {
                      final imageProvider = ImageHelper.getSafeImageProvider(
                        photo.photoUrl,
                      );
                      content = GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.photoDetail.name,
                            extra: {
                              'photoId': photo!.id,
                              'image': photo.photoUrl,
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14.r),
                          child: imageProvider != null
                              ? Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFF5A5A5A),
                                      child: Center(
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white54,
                                          size: 20
                                              .w, // Dynamic size based on grid
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: const Color(0xFF5A5A5A),
                                  child: Center(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white54,
                                      size: 20.w,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    } else if (isPastOrToday) {
                      // Past day with no photo -> Small Dot
                      cellColor = Colors.transparent;
                      content = Center(
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFF5A5A5A),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    } else {
                      // Future day -> Solid Rounded Box
                      cellColor = const Color(0xFF5A5A5A);
                    }

                    return Container(
                      width: itemWidth,
                      height: itemWidth,
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: content,
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
