import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/layout/mother_layout_scaffold.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/growth_record_entity.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/core/widgets/headers/header_primary_features.dart';
import 'package:nusagizi/core/widgets/headers/appbar_action_button.dart';
import 'package:nusagizi/core/widgets/child_picker_bottom_sheet.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/add_new_data_bottom_sheets.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/chart_head_circumference.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/chart_height_card.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/chart_weight_card.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/status_card.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/summary_card.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/latest_growth_report_cubit.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_analyses_cubit.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_history_cubit.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_history_state.dart';

enum GrowthTab { beratBadan, tinggiBadan, lKepala }

class GrowthPage extends StatefulWidget {
  final String? initialChildId;

  const GrowthPage({super.key, this.initialChildId});

  @override
  State<GrowthPage> createState() => _GrowthPageState();
}

class _GrowthPageState extends State<GrowthPage> {
  static const Color _bg = Color(0xFFF5F5F5);
  static const Color _green = Color(0xFF00A735);

  int _selectedChildIndex = 0;

  GrowthTab _activeTab = GrowthTab.beratBadan;

  /// Sub-halaman di dalam tab "Berat Badan": 0=BB/U, 1=BB vs TB, 2=IMT/U
  int _bbSubPage = 0;
  late final PageController _bbPageController;
  late final GoRouterDelegate _routerDelegate;

  @override
  void initState() {
    super.initState();
    _bbPageController = PageController();
    _routerDelegate = GoRouter.of(context).routerDelegate;
    _routerDelegate.addListener(_onRouteChanged);

    _initializeSelectedChild();
  }

  void _initializeSelectedChild() {
    if (widget.initialChildId != null) {
      final childrenList = sl<ChildrenCacheCubit>().state;
      if (childrenList.isNotEmpty) {
        final index = childrenList.indexWhere(
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
    _bbPageController.dispose();
    super.dispose();
  }

  /// Refetch on return if a child page triggered a CRUD operation.
  void _onRouteChanged() {
    if (!mounted) return;
    try {
      final location = _routerDelegate.currentConfiguration.uri.toString();
      if (location == '/home-mother/growth' &&
          motherNavTabNotifier.value == 0) {
        if (crudFlag) {
          _refetch();
          crudFlag = false;
        }
      }
    } catch (_) {}
  }

  /// Fetch latest growth data for the active child.
  void _refetch() {
    if (!mounted) return;
    final childrenList = sl<ChildrenCacheCubit>().state;
    if (childrenList.isEmpty) return;
    final validChild = _selectedChildIndex < childrenList.length
        ? childrenList[_selectedChildIndex]
        : childrenList.first;
    context.read<LatestGrowthReportCubit>().fetchLatestGrowthReport(
      validChild.id,
    );
    context.read<GrowthHistoryCubit>().fetchHistory(validChild.id);
    final analysesCubit = context.read<GrowthAnalysesCubit>();
    analysesCubit.invalidateCache();
    analysesCubit.fetch(
      childId: validChild.id,
      analysisType: 'weight_for_age',
      ageRange: '0-60',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ChildrenCacheCubit>()),
        BlocProvider(
          create: (_) {
            final cubit = sl<LatestGrowthReportCubit>();
            final childrenList = sl<ChildrenCacheCubit>().state;
            if (childrenList.isNotEmpty) {
              final validChild = _selectedChildIndex < childrenList.length
                  ? childrenList[_selectedChildIndex]
                  : childrenList.first;
              cubit.fetchLatestGrowthReport(validChild.id);
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = sl<GrowthAnalysesCubit>();
            final childrenList = sl<ChildrenCacheCubit>().state;
            if (childrenList.isNotEmpty) {
              final validChild = _selectedChildIndex < childrenList.length
                  ? childrenList[_selectedChildIndex]
                  : childrenList.first;
              // Fetch kombinasi yang tampil pertama kali (BB/U, 0-5 Tahun)
              cubit.fetch(
                childId: validChild.id,
                analysisType: 'weight_for_age',
                ageRange: '0-60',
              );
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = sl<GrowthHistoryCubit>();
            final childrenList = sl<ChildrenCacheCubit>().state;
            if (childrenList.isNotEmpty) {
              final validChild = _selectedChildIndex < childrenList.length
                  ? childrenList[_selectedChildIndex]
                  : childrenList.first;
              cubit.fetchHistory(validChild.id);
            }
            return cubit;
          },
        ),
      ],
      child: BlocBuilder<ChildrenCacheCubit, List<ChildHeaderEntity>>(
        builder: (context, childrenList) {
          if (childrenList.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Belum ada data anak.')),
            );
          }

          final validChild = _selectedChildIndex < childrenList.length
              ? childrenList[_selectedChildIndex]
              : childrenList.first;

          final validIndex = _selectedChildIndex < childrenList.length
              ? _selectedChildIndex
              : 0;

          return BlocBuilder<GrowthHistoryCubit, GrowthHistoryState>(
            builder: (context, historyState) {
              List<GrowthRecord> history = [];
              if (historyState is GrowthHistoryLoaded) {
                // Assume newer records come first from API, so reversed for chronological chart
                final list = historyState.history.reversed.toList();
                history = list
                    .map(
                      (e) => GrowthRecord(
                        date: e.measuredAt,
                        weight: e.weightKg ?? 0.0,
                        height: e.heightCm ?? 0.0,
                        headCircumference: e.headCircumferenceCm ?? 0.0,
                      ),
                    )
                    .toList();
              }
              final latest = history.isNotEmpty
                  ? history.last
                  : GrowthRecord(
                      date: DateTime.now(),
                      weight: 0,
                      height: 0,
                      headCircumference: 0,
                    );

              return Scaffold(
                backgroundColor: _bg,
                appBar: HeaderPrimaryFeatures(
                  profile: validChild,
                  accentColor: _green,
                  onPickerTapped: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (bsContext) {
                        return BlocProvider.value(
                          value: sl<ChildrenCacheCubit>(),
                          child: ChildPickerBottomSheet(
                            selectedIndex: validIndex,
                            onChildSelected: (index) {
                              setState(() {
                                _selectedChildIndex = index;
                              });

                              // Gunakan variabel childrenList dari luar (BlocBuilder)
                              final child = childrenList[index];

                              // context di sini mengacu ke context milik GrowthPage
                              context
                                  .read<LatestGrowthReportCubit>()
                                  .fetchLatestGrowthReport(child.id);
                              context.read<GrowthHistoryCubit>().fetchHistory(
                                child.id,
                              );
                            },
                            accentColor: _green,
                          ),
                        );
                      },
                    );
                  },
                  actions: [
                    AppbarActionButton(
                      icon: Icons.history_rounded,
                      onTap: () => context.goNamed(
                        AppRoutes.growthHistory.name,
                        extra: validChild.id,
                      ),
                    ),
                  ],
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            children: [
                              SummaryCard(accentColor: _green),
                              SizedBox(height: 16.h),
                              _tabBar(),
                              SizedBox(height: 16.h),
                              _chartCard(
                                validChild,
                                latest,
                                history,
                                validChild.id,
                              ),
                              SizedBox(height: 16.h),
                              StatusCard(
                                accentColor: _green,
                                profile: validChild,
                                activeTab: _activeTab,
                                bbSubPage: _bbSubPage,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: AddNewDataBottomSheets(
                  accentColor: const Color(0xFF00A735),
                  childId: validChild.id,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _tabBar() {
    const labels = ['Berat Badan', 'Tinggi Badan', 'L.Kepala'];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: GrowthTab.values.asMap().entries.map((e) {
          final isActive = _activeTab == e.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _activeTab = e.value;
                    if (e.value == GrowthTab.beratBadan) {
                      _bbSubPage = 0;
                    }
                  });
                  // jumpToPage dipanggil setelah frame selesai di-build
                  // agar PageController sudah terhubung ke PageView
                  if (e.value == GrowthTab.beratBadan) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_bbPageController.hasClients) {
                        _bbPageController.jumpToPage(0);
                      }
                    });
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isActive ? _green : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      labels[e.key],
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12.sp,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _chartCard(
    ChildHeaderEntity childProfile,
    GrowthRecord latest,
    List<GrowthRecord> history,
    String childId,
  ) => switch (_activeTab) {
    GrowthTab.beratBadan => ChartWeightCard(
      accentColor: _green,
      profile: childProfile,
      latest: latest,
      history: history,
      childId: childId,
      bbSubPage: _bbSubPage,
      bbPageController: _bbPageController,
      onPageChanged: (i) => setState(() => _bbSubPage = i),
      onPrev: () {
        setState(() => _bbSubPage--);
        _bbPageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      onNext: () {
        setState(() => _bbSubPage++);
        _bbPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    ),
    GrowthTab.tinggiBadan => ChartHeightCard(
      profile: childProfile,
      latest: latest,
      history: history,
      childId: childId,
    ),
    GrowthTab.lKepala => ChartHeadCircumference(
      profile: childProfile,
      latest: latest,
      history: history,
      childId: childId,
    ),
  };
}
