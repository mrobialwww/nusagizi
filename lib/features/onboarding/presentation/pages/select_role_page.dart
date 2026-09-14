import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nusagizi/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nusagizi/features/onboarding/presentation/cubit/onboarding_state.dart';

class SelectRolePage extends StatefulWidget {
  const SelectRolePage({super.key});

  @override
  State<SelectRolePage> createState() => _SelectRolePageState();
}

class _SelectRolePageState extends State<SelectRolePage> {
  String? _selectedRole;

  void _submitForm(BuildContext context) {
    if (_selectedRole == null) return;
    context.read<OnboardingCubit>().submitRole(_selectedRole!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(),
      child: Builder(
        builder: (context) {
          return BlocConsumer<OnboardingCubit, OnboardingState>(
            listener: (context, state) {
              if (state is OnboardingSuccess) {
                // Update state AuthCubit agar router merespon instan.
                context.read<AuthCubit>().updateRole(state.role);
              } else if (state is OnboardingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is OnboardingLoading;

              return Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 60.h),

                        // Title
                        Text(
                          'Masuk sebagai siapa?',
                          style: GoogleFonts.outfit(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),

                        // Subtitle
                        Text(
                          'Pilih peranmu untuk mendapatkan\npengalaman yang sesuai kebutuhanmu.',
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 48.h),

                        // Role Cards
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildRoleCard(
                              title: 'Orang Tua',
                              imagePath: AppImages.mother,
                              roleValue: 'mother',
                            ),
                            SizedBox(width: 16.w),
                            _buildRoleCard(
                              title: 'Pengasuh',
                              imagePath: AppImages.caregiver,
                              roleValue: 'caregiver',
                            ),
                          ],
                        ),

                        SizedBox(height: 40.h),
                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF00A735),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: _selectedRole != null
                                      ? () => _submitForm(context)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    disabledBackgroundColor:
                                        Colors.grey.shade400,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Mulai Nusagizi',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedRole != null
                                          ? Colors.white
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String imagePath,
    required String roleValue,
  }) {
    final bool isSelected = _selectedRole == roleValue;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRole = roleValue;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 240, // Fixed height to keep cards equal size
          padding: isSelected
              ? EdgeInsets.only(top: 24.h, bottom: 0.h)
              : EdgeInsets.only(top: 24.h, left: 16.w, right: 16.w, bottom: 24.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF2FBF5) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF00A735)
                  : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF00A735).withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: isSelected
                ? [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        // Make image width stretch to container bounds
                        child: Image.asset(
                          imagePath,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(imagePath, fit: BoxFit.contain),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
