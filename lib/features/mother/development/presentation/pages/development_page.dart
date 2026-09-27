import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/layout/mother_layout_scaffold.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nusagizi/core/config/assets/app_vectors.dart';
import 'package:nusagizi/core/routes/route_args.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/widgets/child_picker_bottom_sheet.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/core/widgets/headers/header_primary_features.dart';
import 'package:nusagizi/core/widgets/headers/appbar_action_button.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_summary_entity.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/development_cubit.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/development_state.dart';
import 'package:nusagizi/features/mother/development/presentation/widgets/development_profile_card.dart';
import 'package:nusagizi/features/mother/development/presentation/widgets/development_summary_card.dart';
import 'package:nusagizi/features/mother/development/presentation/widgets/quick_access_card.dart';

class DevelopmentPage extends StatefulWidget {
  final String? initialChildId;

  const DevelopmentPage({super.key, this.initialChildId});

  @override
  State<DevelopmentPage> createState() => _DevelopmentPageState();
}

class _DevelopmentPageState extends State<DevelopmentPage> {
  static const Color _backgroundColor = Color(0xFFF5F5F5);
  static const Color _accentColor = Color(0xFF00A735);

  late final DevelopmentCubit _cubit = sl<DevelopmentCubit>();
  late final GoRouterDelegate _routerDelegate;

  int _selectedChildIndex = 0;

  @override
  void initState() {
    super.initState();
    _routerDelegate = GoRouter.of(context).routerDelegate;
    _routerDelegate.addListener(_onRouteChanged);

    _initializeSelectedChild();

    final cacheState = sl<ChildrenCacheCubit>().state;
    if (cacheState.isNotEmpty) {
      _cubit.loadSummary(cacheState[_selectedChildIndex].id);
    }
  }

  void _initializeSelectedChild() {
    if (widget.initialChildId != null) {
      final cacheState = sl<ChildrenCacheCubit>().state;
      if (cacheState.isNotEmpty) {
        final index = cacheState.indexWhere(
          (c) => c.id == widget.initialChildId,
        );
        if (index != -1) {
          _selectedChildIndex = index;
        }
      }
    }
  }

  @override
  void dispose() {
    _routerDelegate.removeListener(_onRouteChanged);
    _cubit.close();
    super.dispose();
  }

  // Refetch on return if a child page triggered a CRUD operation.
  void _onRouteChanged() {
    if (!mounted) return;
    try {
      final location = _routerDelegate.currentConfiguration.uri.toString();
      if (location == '/home-mother/development' &&
          motherNavTabNotifier.value == 0) {
        if (crudFlag) {
          _refetch();
          crudFlag = false;
        }
      }
    } catch (_) {}
  }

  // Fetch latest development summary for the active child.
  void _refetch() {
    if (!mounted) return;
    final cacheState = sl<ChildrenCacheCubit>().state;
    if (cacheState.isNotEmpty && _selectedChildIndex < cacheState.length) {
      _cubit.loadSummary(cacheState[_selectedChildIndex].id);
    }
  }

  void _onChildSelected(int index) {
    setState(() => _selectedChildIndex = index);
    final cacheState = sl<ChildrenCacheCubit>().state;
    if (index < cacheState.length) {
      _cubit.loadSummary(cacheState[index].id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ChildrenCacheCubit>(),
      child: BlocBuilder<ChildrenCacheCubit, List<ChildHeaderEntity>>(
        builder: (context, childrenList) {
          if (childrenList.isEmpty) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF00A735)),
              ),
            );
          }

          final validChild = _selectedChildIndex < childrenList.length
              ? childrenList[_selectedChildIndex]
              : childrenList.first;

          final validIndex = _selectedChildIndex < childrenList.length
              ? _selectedChildIndex
              : 0;

          return BlocProvider.value(
            value: _cubit,
            child: Scaffold(
              backgroundColor: _backgroundColor,
              appBar: HeaderPrimaryFeatures(
                profile: validChild,
                onPickerTapped: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return BlocProvider.value(
                        value: sl<ChildrenCacheCubit>(),
                        child: ChildPickerBottomSheet(
                          selectedIndex: validIndex,
                          onChildSelected: _onChildSelected,
                          accentColor: _accentColor,
                        ),
                      );
                    },
                  );
                },
                actions: [
                  AppbarActionButton(
                    icon: Icons.history_rounded,
                    onTap: () => context.goNamed(
                      AppRoutes.developmentHistory.name,
                      extra: validChild,
                    ),
                  ),
                ],
                accentColor: _accentColor,
              ),
              body: SafeArea(
                child: BlocBuilder<DevelopmentCubit, DevelopmentState>(
                  builder: (context, state) {
                    if (state is DevelopmentError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is! DevelopmentLoaded) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00A735),
                        ),
                      );
                    }

                    final summary = state.summary;

                    if (summary == null) {
                      return _buildEmptyAssessment(context, validChild);
                    }

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryCard(summary, validChild),
                          SizedBox(height: 24.h),
                          Text(
                            "Akses Cepat",
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: QuickAccessCard(
                                  title: 'Mulai KPSP',
                                  subtitle:
                                      'Kuesioner Pra Skrining Perkembangan',
                                  icon: Icons.assignment_outlined,
                                  iconColor: const Color(0xFF00A735),
                                  iconBackgroundColor: const Color(0xFFDDEFDD),
                                  onTap: () {
                                    final nextCheckDate = summary.nextCheckDate;
                                    final now = DateTime.now();
                                    final isNextCheckInFuture =
                                        nextCheckDate != null &&
                                        nextCheckDate.isAfter(now);

                                    if (isNextCheckInFuture) {
                                      _showKpspAlreadyDoneDialog(
                                        context,
                                        summary,
                                        validChild,
                                      );
                                    } else {
                                      context.goNamed(
                                        AppRoutes.developmentKpsp.name,
                                        extra: KpspAssessmentExtra(
                                          childName: validChild.name,
                                          childAge: validChild.age,
                                          childId: validChild.id,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: QuickAccessCard(
                                  title: 'Checklist Manual',
                                  subtitle: 'Pantau harian mandiri',
                                  icon: Icons.fact_check_outlined,
                                  iconColor: const Color(0xFFFF9800),
                                  iconBackgroundColor: const Color(0xFFFFEBD6),
                                  onTap: () => context.goNamed(
                                    AppRoutes.developmentChecklist.name,
                                    extra: ChecklistMilestoneExtra(
                                      childId: validChild.id,
                                      childAge: validChild.age,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          DevelopmentProfileCard(
                            childName: validChild.name,
                            childAge: validChild.age,
                            childId: validChild.id,
                            reportId: summary.id,
                            motorikHalus: summary.motorikHalus,
                            motorikKasar: summary.motorikKasar,
                            sosialisasi: summary.sosialisasi,
                            bicara: summary.bicara,
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyAssessment(
    BuildContext context,
    ChildHeaderEntity validChild,
  ) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppVectors.emptyNote, width: 240.w),
                SizedBox(height: 24.h),
                Text(
                  'Belum Ada Asesmen',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.goNamed(
                  AppRoutes.developmentKpsp.name,
                  extra: KpspAssessmentExtra(
                    childName: validChild.name,
                    childAge: validChild.age,
                    childId: validChild.id,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A735),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Mulai Asesmen',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    ChildDevelopmentSummaryEntity summary,
    ChildHeaderEntity child,
  ) {
    return GestureDetector(
      onTap: () => context.goNamed(
        AppRoutes.developmentKpspResult.name,
        extra: KpspResultExtra(
          childName: child.name,
          childAge: child.age,
          reportId: summary.id,
          isFromHistory: true,
          childId: child.id,
        ),
      ),

      child: DevelopmentSummaryCard(
        badgeStatus: summary.badgeStatus,
        lastCheck: summary.lastCheck,
        kpspScore: '${summary.kpspScore}/${summary.kpspTotal}',
        nextCheck: summary.nextCheck,
      ),
    );
  }

  void _showKpspAlreadyDoneDialog(
    BuildContext context,
    ChildDevelopmentSummaryEntity summary,
    ChildHeaderEntity child,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KPSP Sudah Dilakukan',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                    color: const Color(0xFF00A735),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Kamu sudah melakukan KPSP untuk periode usia ini. Hasil tersebut masih berlaku hingga periode berikutnya.',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Jika kamu tetap ingin mengulang asesmen, hasil sebelumnya akan digantikan dengan hasil terbaru.',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.pop();
                          context.goNamed(
                            AppRoutes.developmentKpsp.name,
                            extra: KpspAssessmentExtra(
                              childName: child.name,
                              childAge: child.age,
                              childId: child.id,
                              existingReportId: summary.id,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(0xFF00A735),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            'Ulangi KPSP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: const Color(0xFF00A735),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00A735),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Batal',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
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
  }
}
