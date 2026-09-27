import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/access_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/caregiver_engagement_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/caregiver_engagement_state.dart';

class AccessHistoryPage extends StatelessWidget {
  const AccessHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: const HeaderBasic(
        backgroundColor: Color(0xFFF4F6F4),
        title: 'Riwayat Akses',
      ),
      body: SafeArea(
        child: BlocBuilder<CaregiverEngagementCubit, CaregiverEngagementState>(
          builder: (context, state) {
            if (state is CaregiverEngagementLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF00A735)),
              );
            } else if (state is CaregiverEngagementError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is CaregiverEngagementLoaded) {
              if (state.engagements.isEmpty) {
                return Center(
                  child: Text(
                    'Belum ada riwayat akses',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: Colors.grey.shade600,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0.w,
                  vertical: 10.0.h,
                ),
                child: Column(
                  children: state.engagements
                      .map(
                        (engagement) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: AccessCard(
                            name: engagement.caregiverName,
                            role: 'Pengasuh', // Hardcoded as agreed
                            callNumber: engagement.phoneNumber ?? '-',
                            callNumberIcon: Icons.phone,
                            isPlaceholderAvatar: true,
                            isActive: false,
                            badgeText: engagement.childName,
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
