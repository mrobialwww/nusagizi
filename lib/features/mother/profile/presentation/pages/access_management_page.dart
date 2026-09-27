import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final String? initialChildId;

  const AccessManagementPage({super.key, this.initialChildId});

  @override
  State<AccessManagementPage> createState() => _AccessManagementPageState();
}

class _AccessManagementPageState extends State<AccessManagementPage> {
  @override
  void initState() {
    super.initState();
    if (widget.initialChildId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openInviteBottomSheet(widget.initialChildId!);
      });
    }
  }

  Future<void> _openInviteBottomSheet(String childId) async {
    final childrenCacheCubit = context.read<ChildrenCacheCubit>();
    final cubit = context.read<CaregiverEngagementCubit>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: childrenCacheCubit,
        child: InviteAccessBottomSheet(childId: childId),
      ),
    );
    if (!mounted) return;
    cubit.loadActiveEngagements();
  }

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
              context.pop(); // Close loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Akses pengasuh berhasil dicabut'),
                  backgroundColor: Color(0xFF00A735),
                ),
              );
            } else if (state is CaregiverEngagementDeleteError) {
              context.pop(); // Close loading dialog
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
                            return _buildEmptyState();
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
              final children = childrenCacheCubit.state;
              if (children.isEmpty) return;

              final defaultChildId = children.first.id;
              await _openInviteBottomSheet(defaultChildId);
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
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w500,
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
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
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
                callNumber: engagement.phoneNumber ?? '-',
                callNumberIcon: Icons.phone,
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
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(24.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 80.w,
                                      height: 80.w,
                                      decoration: BoxDecoration(
                                        color: Colors.red[50],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 40.sp,
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    Text(
                                      'Hapus Akses Pengasuh?',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Pengasuh tidak lagi dapat mengakses resep dan mengirim dokumentasi anak.',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 14.sp,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 24.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () =>
                                                dialogContext.pop(),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                color: Colors.red,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 14.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                            ),
                                            child: Text(
                                              'Batal',
                                              style: TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              dialogContext
                                                  .pop(); // Close dialog
                                              context
                                                  .read<
                                                    CaregiverEngagementCubit
                                                  >()
                                                  .revokeEngagement(
                                                    engagement
                                                        .caregiverEngagementId,
                                                  );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              elevation: 0,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 14.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                            ),
                                            child: Text(
                                              'Hapus',
                                              style: TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
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
          _buildEmptyState(),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppVectors.emptySearch, height: 200.h),
          SizedBox(height: 24.h),
          Text(
            'Belum ada pengasuh yang terhubung',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Undang pengasuh agar dapat membantu\nmenjalankan rutinitas harian anak.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: Colors.black54,
              fontSize: 12.sp,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
