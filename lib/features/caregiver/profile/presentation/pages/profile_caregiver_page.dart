import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/routes/route_args.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_profile_cubit.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_profile_state.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/profile_menu_section.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/profile_menu_item.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/logout_dialog.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/delete_account_dialog.dart';
import 'package:nusagizi/router.dart';

class ProfileCaregiverPage extends StatelessWidget {
  const ProfileCaregiverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.h),
              Text(
                'Profil',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 32.h),
              // Profile Picture with glow
              BlocBuilder<CaregiverProfileCubit, CaregiverProfileState>(
                builder: (context, state) {
                  String? photoUrl;
                  if (state is CaregiverProfileLoaded) {
                    photoUrl = state.profile.photoUrl;
                  }

                  return Container(
                    width: 90.r,
                    height: 90.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF00A735,
                          ).withValues(alpha: 0.15),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child:
                        (state is CaregiverProfileLoading ||
                            state is CaregiverProfileInitial)
                        ? Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(30.r),
                            child: const CircularProgressIndicator(
                              color: Color(0xFF00A735),
                            ),
                          )
                        : CircleAvatar(
                            radius: 45.r,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                ImageHelper.getSafeImageProvider(photoUrl) ??
                                ImageHelper.getDefaultUserImage(
                                  state is CaregiverProfileLoaded
                                      ? state.profile.gender
                                      : null,
                                ),
                          ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              // Nama & Email dinamis dari cubit
              BlocBuilder<CaregiverProfileCubit, CaregiverProfileState>(
                builder: (context, state) {
                  final name = state is CaregiverProfileLoaded
                      ? state.profile.fullName
                      : '—';
                  final email = state is CaregiverProfileLoaded
                      ? state.profile.email
                      : '—';
                  return Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        email,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 32.h),

              // Menus
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    ProfileMenuSection(
                      items: [
                        ProfileMenuItem(
                          icon: Icons.person,
                          title: 'Ubah Profil',
                          iconColor: const Color(0xFF00A735),
                          iconBgColor: const Color(0xFFEAF7EE),
                          onTap: () {
                            final state = context
                                .read<CaregiverProfileCubit>()
                                .state;
                            if (state is CaregiverProfileLoaded) {
                              context.pushNamed(
                                AppRoutes.caregiverEditProfile.name,
                                extra: CaregiverEditProfileExtra(
                                  cubit: context.read<CaregiverProfileCubit>(),
                                  profile: state.profile,
                                ),
                              );
                            }
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.alarm,
                          title: 'Jadwal & Pengingat',
                          iconColor: const Color(0xFF00A735),
                          iconBgColor: const Color(0xFFEAF7EE),
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.caregiverReminderAlarm.name,
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.lock,
                          title: 'Keamanan Akun',
                          iconColor: const Color(0xFF00A735),
                          iconBgColor: const Color(0xFFEAF7EE),
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.caregiverChangePassword.name,
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ProfileMenuSection(
                      items: [
                        ProfileMenuItem(
                          icon: Icons.article,
                          title: 'Syarat & Ketentuan',
                          iconColor: Colors.grey[600]!,
                          iconBgColor: Colors.grey[200]!,
                          onTap: () => context.pushNamed(
                            AppRoutes.termsAndConditions.name,
                          ),
                        ),
                        ProfileMenuItem(
                          icon: Icons.help,
                          title: 'Pusat Bantuan',
                          iconColor: Colors.grey[600]!,
                          iconBgColor: Colors.grey[200]!,
                          onTap: () =>
                              context.pushNamed(AppRoutes.helpCenter.name),
                        ),
                        ProfileMenuItem(
                          icon: Icons.language,
                          title: 'Bahasa',
                          iconColor: Colors.grey[600]!,
                          iconBgColor: Colors.grey[200]!,
                          trailingText: 'Bahasa Indonesia',
                          onTap: () => context.pushNamed(
                            AppRoutes.languageSettings.name,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ProfileMenuSection(
                      items: [
                        ProfileMenuItem(
                          icon: Icons.delete,
                          title: 'Hapus Akun',
                          iconColor: Colors.red,
                          iconBgColor: Colors.red[50]!,
                          hideChevron: true,
                          onTap: () {
                            showDeleteAccountDialog(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showLogoutDialog(context);
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Color(0xFF00A735),
                        ),
                        label: Text(
                          'Keluar',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: const Color(0xFF00A735),
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(
                            color: Color(0xFF00A735),
                            width: 1.5,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
