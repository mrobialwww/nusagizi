import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';

class ProfileDropdown extends StatefulWidget {
  const ProfileDropdown({super.key});

  @override
  State<ProfileDropdown> createState() => _ProfileDropdownState();
}

class _ProfileDropdownState extends State<ProfileDropdown> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ChildrenCacheCubit>(),
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () => _showDropdownOverlay(context),
            child: CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(AppImages.childHome1),
            ),
          );
        },
      ),
    );
  }

  void _showDropdownOverlay(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final children = context.read<ChildrenCacheCubit>().state;

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Detect tap outside to dismiss
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              top: offset.dy + size.height + 8,
              right: 20, // Padding from right edge
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF4A4A4A,
                    ), // Dark gray similar to image
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(children.length, (index) {
                      final child = children[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: AssetImage(
                                  AppImages.childHome1,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                child.name,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
