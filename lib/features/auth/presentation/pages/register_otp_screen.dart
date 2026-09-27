import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_state.dart';
import 'package:nusagizi/router.dart';

class RegisterOtpScreen extends StatefulWidget {
  const RegisterOtpScreen({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  State<RegisterOtpScreen> createState() => _RegisterOtpScreenState();
}

class _RegisterOtpScreenState extends State<RegisterOtpScreen> {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  int _resendCooldown = 30;
  Timer? _timer;

  // Sesuaikan panjang OTP jika Auth0 Anda menggunakan 6 digit
  final int _otpLength = 4;

  @override
  void initState() {
    super.initState();
    _startCooldown();
    // Keep UI in sync with every keystroke (boxes + verify button).
    _otpController.addListener(() {
      if (mounted) setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _startCooldown() {
    setState(() => _resendCooldown = 30);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_resendCooldown <= 1) {
        timer.cancel();
        setState(() => _resendCooldown = 0);
      } else {
        setState(() => _resendCooldown--);
      }
    });
  }

  void _resendOtp() {
    context.read<AuthCubit>().resendOtp(email: widget.email);
    _startCooldown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kode OTP telah dikirim ulang.'),
        backgroundColor: Color(0xFF00A735),
      ),
    );
  }

  void _verify() {
    if (_otpController.text.length != _otpLength) return;
    FocusScope.of(context).unfocus();

    context.read<AuthCubit>().verifyOtpAndLogin(
      email: widget.email,
      otpCode: _otpController.text.trim(),
      password: widget.password,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOtpFilled = _otpController.text.length == _otpLength;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.goNamed(AppRoutes.selectRole.name);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(AppRoutes.login.name);
                }
              },
            ),
            title: Text(
              'Verifikasi Email',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 32.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  color: Colors.black87,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        'Masukkan kode verifikasi yang telah dikirim melalui ',
                                  ),
                                  TextSpan(
                                    text: widget.email,
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 32.h),
                            Text(
                              'Kode Verifikasi',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                color: Colors.grey.shade600,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // Custom OTP Input
                            Stack(
                              children: [
                                // Visual OTP boxes (behind, display only)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(_otpLength, (index) {
                                    final text = _otpController.text;
                                    final char = index < text.length
                                        ? text[index]
                                        : '';
                                    final isFocused =
                                        _focusNode.hasFocus &&
                                        (index == text.length ||
                                            (index == _otpLength - 1 &&
                                                text.length == _otpLength));
                                    final hasValue = char.isNotEmpty;

                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 64.w,
                                      height: 64.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        border: Border.all(
                                          color: hasValue || isFocused
                                              ? const Color(0xFF00A735)
                                              : Colors.grey.shade300,
                                          width: hasValue || isFocused ? 2 : 1,
                                        ),
                                      ),
                                      child: Text(
                                        char,
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }),
                                ),

                                // Real TextField on top — receives taps and
                                // manages focus + keyboard natively via the
                                // platform channel, so it works reliably
                                // after app resume (e.g., from email app).
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.0,
                                    child: TextField(
                                      controller: _otpController,
                                      focusNode: _focusNode,
                                      keyboardType: TextInputType.number,
                                      maxLength: _otpLength,
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        counterText: '',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 24.h),
                            Text(
                              'Tidak menerima kode verifikasi?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                color: Colors.grey.shade600,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            GestureDetector(
                              onTap: (_resendCooldown == 0 && !isLoading)
                                  ? _resendOtp
                                  : null,
                              child: Text(
                                _resendCooldown > 0
                                    ? 'Kirim ulang dalam 00:${_resendCooldown.toString().padLeft(2, '0')}'
                                    : 'Kirim ulang',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  color: _resendCooldown > 0
                                      ? Colors.black
                                      : const Color(0xFF00A735),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Verify button
                        Padding(
                          padding: EdgeInsets.only(top: 24.h),
                          child: SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: (isOtpFilled && !isLoading)
                                  ? _verify
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isOtpFilled
                                    ? const Color(0xFF00A735)
                                    : Colors.grey.shade300,
                                foregroundColor: isOtpFilled
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                disabledBackgroundColor: Colors.grey.shade300,
                                disabledForegroundColor: Colors.grey.shade500,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF00A735),
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      'Verifikasi',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
