import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nusagizi/core/config/assets/app_vectors.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/access_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/caregiver_engagement_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/caregiver_engagement_state.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/invite_access_bottom_sheet.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';

class AccessManagementPage extends StatefulWidget {
  const AccessManagementPage({super.key});

  @override
  State<AccessManagementPage> createState() => _AccessManagementPageState();
}

class _AccessManagementPageState extends State<AccessManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: HeaderBasic(
        backgroundColor: const Color(0xFFF4F6F4),
        title: 'Manajemen Akses',
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: Icon(Icons.history, color: Colors.black, size: 20.sp),
            ),
            onPressed: () => context.goNamed(AppRoutes.accessHistory.name),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocListener<CaregiverEngagementCubit, CaregiverEngagementState>(
          listener: (context, state) {
            if (state is CaregiverEngagementDeleteLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00A735)),
                ),
              );
            } else if (state is CaregiverEngagementDeleteSuccess) {
              Navigator.pop(context); // Close loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Akses pengasuh berhasil dicabut'),
                  backgroundColor: Color(0xFF00A735),
                ),
              );
            } else if (state is CaregiverEngagementDeleteError) {
              Navigator.pop(context); // Close loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Expanded(
                child:
                    BlocBuilder<
                      CaregiverEngagementCubit,
                      CaregiverEngagementState
                    >(
                      buildWhen: (previous, current) =>
                          current is CaregiverEngagementLoading ||
                          current is CaregiverEngagementError ||
                          current is CaregiverEngagementLoaded,
                      builder: (context, state) {
                        if (state is CaregiverEngagementLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF00A735),
                            ),
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppVectors.emptyCaregiver,
                                    height: 160.h,
                                  ),
                                  SizedBox(height: 24.h),
                                  Text(
                                    'Belum ada pengasuh yang terhubung',
                                    style: GoogleFonts.outfit(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Undang pengasuh agar dapat membantu\nmenjalankan rutinitas harian anak.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      color: Colors.black54,
                                      fontSize: 12.sp,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                            child: _buildPengasuhTab(state.engagements),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.0.w),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () async {
              final childrenCacheCubit = context.read<ChildrenCacheCubit>();
              final cubit = context.read<CaregiverEngagementCubit>();
              final children = childrenCacheCubit.state;

              if (children.isEmpty) return;
              final defaultChildId = children.first.id;
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => BlocProvider.value(
                  value: childrenCacheCubit,
                  child: InviteAccessBottomSheet(childId: defaultChildId),
                ),
              );
              if (!mounted) return;
              cubit.loadActiveEngagements();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A735),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Tambah Pengasuh',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPengasuhTab(List engagements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (engagements.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.only(bottom: 12.0.h),
            child: Text(
              'Pengasuh Aktif',
              style: GoogleFonts.outfit(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
              ),
            ),
          ),
          ...engagements.map(
            (engagement) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: AccessCard(
                name: engagement.caregiverName,
                role: 'Pengasuh',
                location: engagement.phoneNumber ?? '-',
                locationIcon: Icons.phone,
                isPlaceholderAvatar: true,
                isActive: true,
                badgeText: engagement.childName,
                actions: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Text(
                                'Cabut Akses',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text(
                                'Apakah Anda yakin ingin mencabut akses untuk pengasuh ini?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: Text(
                                    'Batal',
                                    style: GoogleFonts.outfit(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      dialogContext,
                                    ); // Close dialog
                                    context
                                        .read<CaregiverEngagementCubit>()
                                        .revokeEngagement(
                                          engagement.caregiverEngagementId,
                                        );
                                  },
                                  child: Text(
                                    'Ya, Cabut',
                                    style: GoogleFonts.outfit(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEBEB),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 18.sp,
                      ),
                      label: Text(
                        'Hapus Akses',
                        style: GoogleFonts.outfit(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Center(
            child: Column(
              children: [
                SvgPicture.asset(AppVectors.emptyCaregiver, height: 160),
                SizedBox(height: 24.h),
                Text(
                  'Belum ada pengasuh yang terhubung',
                  style: GoogleFonts.outfit(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Undang pengasuh agar dapat membantu\nmenjalankan rutinitas harian anak.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: Colors.black54,
                    fontSize: 12.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
