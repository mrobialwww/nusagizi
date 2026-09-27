import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nusagizi/core/config/assets/app_vectors.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/core/routes/route_args.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_history_entity.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/development_history_cubit.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/development_history_state.dart';
import 'package:nusagizi/features/mother/development/presentation/widgets/history_timeline_card.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';

class DevelopmentHistoryPage extends StatefulWidget {
  const DevelopmentHistoryPage({super.key, this.selectedChild});

  final ChildHeaderEntity? selectedChild;

  @override
  State<DevelopmentHistoryPage> createState() => _DevelopmentHistoryPageState();
}

class _DevelopmentHistoryPageState extends State<DevelopmentHistoryPage> {
  late final DevelopmentHistoryCubit _cubit = sl<DevelopmentHistoryCubit>();

  @override
  void initState() {
    super.initState();
    final cacheState = sl<ChildrenCacheCubit>().state;
    final childToLoad =
        widget.selectedChild ??
        (cacheState.isNotEmpty ? cacheState.first : null);

    if (childToLoad != null) {
      _cubit.loadHistory(childToLoad.id);
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const HeaderBasic(
        backgroundColor: Color(0xFFF5F5F5),
        title: 'Riwayat Asesmen',
      ),
      body: BlocProvider.value(
        value: sl<ChildrenCacheCubit>(),
        child: BlocConsumer<ChildrenCacheCubit, List<ChildHeaderEntity>>(
          listenWhen: (prev, curr) => prev.isEmpty && curr.isNotEmpty,
          listener: (context, childrenList) {
            _cubit.loadHistory(childrenList.first.id);
          },
          builder: (context, childrenList) {
            if (childrenList.isEmpty && widget.selectedChild == null) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF00A735)),
              );
            }

            final child = widget.selectedChild ?? childrenList.first;

            return BlocProvider.value(
              value: _cubit,
              child:
                  BlocBuilder<DevelopmentHistoryCubit, DevelopmentHistoryState>(
                    builder: (context, state) {
                      if (state is DevelopmentHistoryLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00A735),
                          ),
                        );
                      }

                      if (state is DevelopmentHistoryError) {
                        return Center(child: Text(state.message));
                      }

                      if (state is DevelopmentHistoryLoaded) {
                        final history = state.historyData;

                        if (history.isEmpty) {
                          return _buildEmptyState();
                        }

                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 24.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ...history.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                return _buildHistoryItem(
                                  context,
                                  item,
                                  child,
                                  index == 0,
                                  index == history.length - 1,
                                  showRetakeButton: index == 0,
                                );
                              }),
                              if (history.isNotEmpty) SizedBox(height: 24.h),
                              // _buildNewAssessmentCard(context, child),
                            ],
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    ChildDevelopmentHistoryEntity record,
    ChildHeaderEntity child,
    bool isFirst,
    bool isLast, {
    bool showRetakeButton = true,
  }) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.developmentKpspResult.name,
          extra: KpspResultExtra(
            childName: child.name,
            childAge: '${record.monthTarget} Bulan',
            reportId: record.id,
            isFromHistory: true,
            childId: child.id,
            showRetakeButton: showRetakeButton,
          ),
        );
      },
      child: HistoryTimelineCard(
        isFirst: isFirst,
        isLast: isLast,
        date: record.createdAt.toIso8601String().substring(0, 10),
        monthTitle: 'Bulan ${record.monthTarget}',
        kpspScore: record.kpspScore,
        status: record.status,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.only(bottom: 90.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppVectors.emptyNote, width: 250.w),
            SizedBox(height: 24.h),
            Text(
              'Belum Ada Riwayat Asesmen',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                'Pantau tumbuh kembang si kecil dengan klik tombol Mulai Asesmen di bawah untuk memilih metode tes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
