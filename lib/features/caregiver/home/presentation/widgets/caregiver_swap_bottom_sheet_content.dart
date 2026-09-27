import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_substitute_item_entity.dart';
import 'package:go_router/go_router.dart';

class CaregiverSwapBottomSheetContent extends StatefulWidget {
  final String itemName;
  final String amount;
  final String? childName;
  final List<CaregiverSubstituteItemEntity> options;

  /// Called when user confirms the swap. Provides the selected item name.
  final void Function(String selectedSubstituteName)? onSwapConfirmed;

  const CaregiverSwapBottomSheetContent({
    super.key,
    required this.itemName,
    required this.amount,
    required this.options,
    this.childName,
    this.onSwapConfirmed,
  });

  @override
  State<CaregiverSwapBottomSheetContent> createState() =>
      _CaregiverSwapBottomSheetContentState();
}

class _CaregiverSwapBottomSheetContentState
    extends State<CaregiverSwapBottomSheetContent> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) {
      return const SizedBox.shrink(); // Safety check
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 12.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            widget.childName != null
                ? "Ganti untuk ${widget.childName}"
                : "Ganti ${widget.itemName}",
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🥣", style: TextStyle(fontSize: 16.sp)),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.itemName,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: [
                        Text(
                          "(${widget.amount})",
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 14.w,
                          color: Colors.grey.shade600,
                        ),
                        Text(
                          "Pilih di bawah",
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00A735),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          ...List.generate(widget.options.length, (index) {
            final option = widget.options[index];
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE5F6EB)
                      : const Color(0xFFFCFCF9),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF00A735)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "🍚",
                      style: TextStyle(fontSize: 20.sp),
                    ), // Default emoji
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.name,
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            option.unit,
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    if (isSelected)
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00A735),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16.w,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                final selected = widget.options[_selectedIndex];
                widget.onSwapConfirmed?.call(selected.name);
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A735),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Text(
                "Ganti ke ${widget.options[_selectedIndex].name}",
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: OutlinedButton(
              onPressed: () {
                context.pop();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00A735)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                "Batalkan",
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF00A735),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
