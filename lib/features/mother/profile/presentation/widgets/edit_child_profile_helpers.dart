import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildStepHeader(String stepName, String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        stepName,
        style: GoogleFonts.outfit(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 4.h),
      Text(
        title,
        style: GoogleFonts.outfit(
          color: Colors.black87,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Widget buildLabel(String text, {bool isRequired = true}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.0.h),
    child: RichText(
      text: TextSpan(
        text: text,
        style: GoogleFonts.outfit(
          color: Colors.black87,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: '*',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    ),
  );
}

Widget buildTextField({required String hint, IconData? suffixIcon}) {
  return TextFormField(
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.outfit(color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: Color(0xFF00A735)),
      ),
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, color: Colors.grey, size: 20.sp)
          : null,
    ),
  );
}

Widget buildTextArea(String hint) {
  return TextFormField(
    maxLines: 4,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 13.sp),
      contentPadding: EdgeInsets.all(16.w),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: Color(0xFF00A735)),
      ),
    ),
  );
}

Widget buildRadioItem(String value) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Radio<String>(
        value: value,
        activeColor: const Color(0xFF00A735),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      Text(
        value,
        style: GoogleFonts.outfit(
          color: Colors.black87,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Widget buildRadioColumnItem(String value) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.0.h),
    child: Row(
      children: [
        SizedBox(
          width: 24.w,
          height: 24.w,
          child: Radio<String>(
            value: value,
            activeColor: const Color(0xFF00A735),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.outfit(color: Colors.black87, fontSize: 13.sp),
          ),
        ),
      ],
    ),
  );
}

Widget buildChip(String label, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF00A735) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? const Color(0xFF00A735) : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          color: isSelected ? Colors.white : Colors.grey.shade600,
          fontSize: 13.sp,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    ),
  );
}

Widget buildActionChip(String label, Color color) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Text(
      label,
      style: GoogleFonts.outfit(
        color: Colors.white,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget buildOtherBox(String hint) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lainnya',
          style: GoogleFonts.outfit(
            color: Colors.grey.shade600,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.outfit(
              color: Colors.grey.shade400,
              fontSize: 13.sp,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(color: Color(0xFF00A735)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(
                color: Color(0xFF00A735),
                width: 1.5,
              ),
            ),
          ),
          style: GoogleFonts.outfit(color: Colors.black87, fontSize: 13.sp),
        ),
      ],
    ),
  );
}
