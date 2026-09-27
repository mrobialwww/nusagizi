import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48.w,
        height: 28.h,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: value ? const Color(0xFF00A735) : Colors.white,
          border: Border.all(
            color: value ? const Color(0xFF00A735) : Colors.grey.shade500,
            width: 1.5,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22.w,
            height: 22.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? Colors.white : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }
}
