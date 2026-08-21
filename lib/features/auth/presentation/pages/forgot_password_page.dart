import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/config/assets/app_vectors.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/router.dart';

class ForgotPasswordPage extends StatelessWidget {
  final String? emailSentRouteName;

  const ForgotPasswordPage({super.key, this.emailSentRouteName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderBasic(
        backgroundColor: Colors.white,
        title: '',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24.h),
            Text(
              "Lupa kata sandi?",
              style: GoogleFonts.outfit(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "Silakan masukkan alamat email Anda untuk\nmenerima kode verifikasi",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            SizedBox(height: 40.h),

            // Email illustration
            SvgPicture.asset(
              AppVectors.forgotPassword,
              height: 180,
            ),

            SizedBox(height: 48.h),

            // Email field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email*",
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.outfit(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: "anggio@gmail.com",
                  hintStyle: GoogleFonts.outfit(fontSize: 14.sp, color: Colors.black38),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Ingat kata sandi?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ingat kata sandi? ",
                  style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.black54),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Text(
                    "Masuk",
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF00A735),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Kirim button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.pushNamed(emailSentRouteName ?? AppRoutes.emailSent.name),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A735),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Kirim",
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
