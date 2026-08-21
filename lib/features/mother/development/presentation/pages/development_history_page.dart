import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/di/service_locator.dart';
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
  static const Color _green = Color(0xFF00A735);
  static const Color _bg = Color(0xFFF5F5F5);

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
      backgroundColor: _bg,
      appBar: const HeaderBasic(backgroundColor: _bg, title: 'Riwayat Asesmen'),
      body: BlocProvider.value(
        value: sl<ChildrenCacheCubit>(),
        child: BlocConsumer<ChildrenCacheCubit, List<ChildHeaderEntity>>(
          listenWhen: (prev, curr) => prev.isEmpty && curr.isNotEmpty,
          listener: (context, childrenList) {
            _cubit.loadHistory(childrenList.first.id);
          },
          builder: (context, childrenList) {
            if (childrenList.isEmpty && widget.selectedChild == null) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF00A735)));
            }

            final child = widget.selectedChild ?? childrenList.first;

            return BlocProvider.value(
              value: _cubit,
              child:
                  BlocBuilder<DevelopmentHistoryCubit, DevelopmentHistoryState>(
                    builder: (context, state) {
                      if (state is DevelopmentHistoryLoading) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF00A735)));
                      }

                      if (state is DevelopmentHistoryError) {
                        return Center(child: Text(state.message));
                      }

                      if (state is DevelopmentHistoryLoaded) {
                        final history = state.historyData;
                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 24.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (history.isEmpty)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: Text(
                                    "Belum ada riwayat asesmen.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      color: Colors.black54,
                                    ),
                                  ),
                                )
                              else
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
    final statusColor = record.status == 'Sesuai Usia'
        ? _green
        : (record.status == 'Perkembangan meragukan'
              ? Colors.orange
              : Colors.red);

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
        type: HistoryType.kpsp,
        date: record.createdAt.toIso8601String().substring(
          0,
          10,
        ), // Short date parsing for now
        monthTitle: 'Bulan ${record.monthTarget}',
        contentWidget: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: statusColor, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(
                '${record.kpspScore}',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: statusColor,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.status,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                      color: statusColor,
                    ),
                  ),
                  Text(
                    'Asesmen KPSP',
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
