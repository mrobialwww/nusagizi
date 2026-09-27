import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
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
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'Belum ada data anak.',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
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
                        contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: const Color(0xFFDDEFDD),
                              backgroundImage:
                                  ImageHelper.getSafeImageProvider(
                                    child.imagePath,
                                  ) ??
                                  ImageHelper.getDefaultChildImage(
                                    child.gender,
                                  ),
                            ),
                            if (isSelected)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
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
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          child.age,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                        trailing: Container(
                          padding: EdgeInsets.all(4.w),
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
                          context.pop();
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
