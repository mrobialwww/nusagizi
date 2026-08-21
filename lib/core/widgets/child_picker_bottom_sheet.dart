import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/core/utils/image_helper.dart';

class ChildPickerBottomSheet extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChildSelected;
  final Color accentColor;

  const ChildPickerBottomSheet({
    super.key,
    required this.selectedIndex,
    required this.onChildSelected,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 24.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          Text(
            'Pilih Anak',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          BlocBuilder<ChildrenCacheCubit, List<ChildHeaderEntity>>(
            builder: (context, childrenList) {
              if (childrenList.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Belum ada data anak.',
                    style: GoogleFonts.outfit(color: Colors.grey),
                  ),
                );
              }

              return Column(
                children: List.generate(childrenList.length, (index) {
                  final child = childrenList[index];
                  final isSelected = index == selectedIndex;

                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  ImageHelper.getSafeImageProvider(
                                        child.imagePath,
                                      ) ==
                                      null
                                  ? ImageHelper.getAvatarColor(child.name)
                                  : const Color(0xFFDDEFDD),
                              backgroundImage: ImageHelper.getSafeImageProvider(
                                child.imagePath,
                              ),
                              child:
                                  ImageHelper.getSafeImageProvider(
                                        child.imagePath,
                                      ) ==
                                      null
                                  ? Text(
                                      ImageHelper.getInitials(child.name),
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    )
                                  : null,
                            ),
                            if (isSelected)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 12.sp,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          child.name,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          child.age,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chevron_right,
                            size: 16.sp,
                            color: Colors.black54,
                          ),
                        ),
                        onTap: () {
                          onChildSelected(index);
                          Navigator.pop(context);
                        },
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF0F0F0),
                      ),
                    ],
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
