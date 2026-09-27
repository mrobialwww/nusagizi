import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoteSelectionSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const NoteSelectionSheet({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.black87,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.shade200,
                height: 1,
                indent: 24,
                endIndent: 24,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: () {
                    onSelected(item);
                    context.pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: Colors.black87,
                        fontSize: 14.sp,
                        fontWeight: item == selectedValue
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
