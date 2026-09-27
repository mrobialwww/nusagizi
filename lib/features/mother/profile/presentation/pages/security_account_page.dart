import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/router.dart';

class SecurityAccountPage extends StatefulWidget {
  const SecurityAccountPage({super.key});

  @override
  State<SecurityAccountPage> createState() => _SecurityAccountPageState();
}

class _SecurityAccountPageState extends State<SecurityAccountPage> {
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderBasic(
        title: "Keamanan Akun",
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ubah Kata Sandi",
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24.h),

            // Kata Sandi Lama
            Text(
              "Kata Sandi Lama",
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12.sp,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            _buildTextField(
              hint: "******",
              obscureText: _obscureOld,
              onToggleObscure: () {
                setState(() {
                  _obscureOld = !_obscureOld;
                });
              },
            ),
            SizedBox(height: 16.h),

            // Kata Sandi Baru
            Text(
              "Kata Sandi Baru",
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12.sp,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            _buildTextField(
              hint: "******",
              obscureText: _obscureNew,
              onToggleObscure: () {
                setState(() {
                  _obscureNew = !_obscureNew;
                });
              },
            ),
            SizedBox(height: 16.h),

            // Konfirmasi Kata Sandi Baru
            Text(
              "Konfirmasi Kata Sandi Baru",
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12.sp,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            _buildTextField(
              hint: "******",
              obscureText: _obscureConfirm,
              onToggleObscure: () {
                setState(() {
                  _obscureConfirm = !_obscureConfirm;
                });
              },
            ),
            SizedBox(height: 16.h),

            // Lupa kata sandi
            GestureDetector(
              onTap: () {
                context.goNamed(AppRoutes.forgotPassword.name);
              },
              child: Text(
                "Lupa kata sandi?",
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF00A735),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        obscureText: obscureText,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14.sp,
            color: Colors.black38,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade400,
              size: 20.sp,
            ),
            onPressed: onToggleObscure,
          ),
        ),
      ),
    );
  }
}
