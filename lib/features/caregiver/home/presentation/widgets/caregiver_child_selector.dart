import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';

class CaregiverChildSelector extends StatelessWidget {
  final List<Map<String, dynamic>> children;
  final int selectedIndex;
  final ValueChanged<int> onChildSelected;

  const CaregiverChildSelector({
    super.key,
    required this.children,
    required this.selectedIndex,
    required this.onChildSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: children.length + 1,
        itemBuilder: (context, index) {
          if (index == children.length) {
            return _buildScanQrButton(context);
          }
          final child = children[index];
          final isSelected = index == selectedIndex;
          return _buildChildAvatar(child, isSelected, index);
        },
      ),
    );
  }

  Widget _buildScanQrButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.caregiverQR.name),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(left: 8.0.w, right: 16.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 70.w,
              width: 70.w,
              child: Center(
                child: Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1.w),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: Color(0xFF00A735),
                    size: 28.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Scan QR',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12.sp,
                color: const Color(0xFF00A735),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildAvatar(
    Map<String, dynamic> child,
    bool isSelected,
    int index,
  ) {
    return GestureDetector(
      onTap: () => onChildSelected(index),
      child: Padding(
        padding: EdgeInsets.only(right: 16.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 70.w,
              width: 70.w,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(isSelected ? 3.w : 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: const Color(0xFF00A735), width: 2.w)
                        : null,
                  ),
                  child: CircleAvatar(
                    radius: 30.r,
                    backgroundImage:
                        (child['image'] != null &&
                            child['image'].toString().isNotEmpty)
                        ? NetworkImage(child['image']) as ImageProvider
                        : const AssetImage(AppImages.defaultMaleChildProfile),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              child['name'],
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12.sp,
                color: isSelected ? const Color(0xFF00A735) : Colors.black87,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
