import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nusagizi/core/config/assets/app_vectors.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderBasic(title: 'Bahasa', backgroundColor: Colors.white),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppVectors.emptySearch, height: 180.h),
              SizedBox(height: 32.h),
              Text(
                "Ups! Belum Tersedia \u26A0\uFE0F",
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Pengaturan Bahasa sedang dalam tahap pengembangan. Pantau terus update selanjutnya dari Nusagizi, ya!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }
}
