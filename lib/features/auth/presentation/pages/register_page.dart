import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  AnimationController? _animController;
  Animation<double>? _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController!,
      curve: Curves.easeInOut,
    );
    _animController!.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _animController?.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    context.goNamed(AppRoutes.login.name);
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().startRegistration(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  void _handleGoogleLogin() {
    context.read<AuthCubit>().googleLogin();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpPending) {
          // Signup + OTP berhasil dikirim → navigasi ke layar verifikasi OTP.
          // Password diteruskan via extra (in-memory, tidak ditulis ke disk).
          context.goNamed(
            AppRoutes.registerOtp.name,
            extra: {'email': state.email, 'password': state.password},
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final _isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: HeaderBasic(
            backgroundColor: Colors.white,
            title: 'Buat Akun Nusagizi',
            onBackPressed: () {
              context.goNamed(AppRoutes.landing.name);
            },
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: FadeTransition(
                  opacity: _fadeAnim ?? const AlwaysStoppedAnimation(1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      // Image
                      Center(
                        child: Image.asset(
                          AppImages.register,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Username
                            _buildLabel('Nama Pengguna*'),
                            SizedBox(height: 8.h),
                            _buildTextField(
                              controller: _usernameController,
                              hintText: 'Anggi Liana',
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Username wajib diisi'
                                  : null,
                            ),
                            SizedBox(height: 16.h),

                            // Email
                            _buildLabel('Email*'),
                            SizedBox(height: 8.h),
                            _buildTextField(
                              controller: _emailController,
                              hintText: 'anggip@gmail.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Email wajib diisi';
                                }
                                if (!v.contains('@')) {
                                  return 'Format email tidak valid';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),

                            // Password
                            _buildLabel('Kata Sandi*'),
                            SizedBox(height: 8.h),
                            _buildTextField(
                              controller: _passwordController,
                              hintText: '******',
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey,
                                  size: 20.sp,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Password wajib diisi';
                                }
                                if (v.length < 8) {
                                  return 'Password minimal 8 karakter';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 32.h),

                            // Submit button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF00A735),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: _handleSubmit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF00A735,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'Daftar',
                                        style: GoogleFonts.outfit(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              'Atau Daftar dengan',
                              style: GoogleFonts.outfit(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Google Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          icon: Icon(
                            Icons.g_mobiledata,
                            color: Color(0xFF00A735),
                            size: 30.sp,
                          ),
                          label: Text(
                            'Masuk dengan Google',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF00A735),
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF00A735)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: _isLoading ? null : _handleGoogleLogin,
                        ),
                      ),

                      SizedBox(height: 48.h),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah memiliki akun? ',
                            style: GoogleFonts.outfit(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: _navigateToLogin,
                            child: Text(
                              'Masuk',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF00A735),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    if (text.endsWith('*')) {
      final baseText = text.substring(0, text.length - 1);
      return RichText(
        text: TextSpan(
          text: baseText,
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
          children: [
            TextSpan(
              text: '*',
              style: GoogleFonts.outfit(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      );
    }

    return Text(
      text,
      style: GoogleFonts.outfit(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.outfit(color: Colors.black),
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 14.sp),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF00A735), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.redAccent.withValues(alpha: 0.7),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: GoogleFonts.outfit(
          color: Colors.redAccent,
          fontSize: 12.sp,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
