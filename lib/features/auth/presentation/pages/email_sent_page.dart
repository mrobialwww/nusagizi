import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/config/assets/app_vectors.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';

class EmailSentPage extends StatelessWidget {
  const EmailSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderBasic(backgroundColor: Colors.white, title: ''),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24.h),
            Text(
              "Email telah dikirim!",
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "Silakan periksa kotak masuk Anda dan klik tautan\nyang diterima untuk mereset kata sandi",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            SizedBox(height: 60.h),

            // Email sent illustration
            SvgPicture.asset(AppVectors.emailSent, height: 200),
            const Spacer(),

            // Masuk button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to login or profile
                  context.pop();
                  context.pop();
                },
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
                  "Masuk",
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Belum menerima tautan?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Belum menerima tautan? ",
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Text(
                    "Kirim Kembali",
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00A735),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
