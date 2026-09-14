import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';

class ChildDropdown extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String>? onChanged;

  const ChildDropdown({super.key, required this.initialValue, this.onChanged});

  @override
  State<ChildDropdown> createState() => _ChildDropdownState();
}

class _ChildDropdownState extends State<ChildDropdown> {
  late String _selectedChildName;

  @override
  void initState() {
    super.initState();
    _selectedChildName = widget.initialValue;
  }

  String _getAvatarForIndex(int index) {
    if (index % 2 == 0) return AppImages.childHome1;
    return AppImages.childHome1;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final renderBox = context.findRenderObject() as RenderBox;
        final offset = renderBox.localToGlobal(Offset.zero);
        final children = context.read<ChildrenCacheCubit>().state;

        showDialog(
          context: context,
          barrierColor: Colors.black54,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            alignment: Alignment.topCenter,
            insetPadding: EdgeInsets.only(
              top: offset.dy + renderBox.size.height + 16,
              left: 40,
              right: 40,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: children.length,
                itemBuilder: (context, index) {
                  final child = children[index];
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedChildName = child.name);
                      widget.onChanged?.call(child.name);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14.r,
                            backgroundImage: AssetImage(
                              _getAvatarForIndex(index),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            child.name,
                            style: GoogleFonts.outfit(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _selectedChildName,
            style: GoogleFonts.outfit(
              color: Colors.black87,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
        ],
      ),
    );
  }
}
