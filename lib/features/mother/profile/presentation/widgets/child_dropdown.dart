import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';

class ChildDropdown extends StatefulWidget {
  final String? initialChildId;
  final ValueChanged<String>? onChanged;

  const ChildDropdown({super.key, this.initialChildId, this.onChanged});

  @override
  State<ChildDropdown> createState() => _ChildDropdownState();
}

class _ChildDropdownState extends State<ChildDropdown> {
  String? _selectedChildId;

  @override
  void initState() {
    super.initState();
    _selectedChildId = widget.initialChildId;
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
                      setState(() => _selectedChildId = child.id);
                      widget.onChanged?.call(child.id);
                      context.pop();
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
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
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
          Builder(
            builder: (context) {
              final children = context.read<ChildrenCacheCubit>().state;
              String displayName = 'Anak';
              if (children.isNotEmpty) {
                if (_selectedChildId != null) {
                  try {
                    displayName = children
                        .firstWhere((c) => c.id == _selectedChildId)
                        .name;
                  } catch (_) {
                    displayName = children.first.name;
                  }
                } else {
                  displayName = children.first.name;
                }
              }
              return Text(
                displayName,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: Colors.black87,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          SizedBox(width: 8.w),
          Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
        ],
      ),
    );
  }
}
