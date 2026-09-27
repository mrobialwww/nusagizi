import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_history_cubit.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_history_state.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/history_record_card.dart';

class GrowthHistoryPage extends StatefulWidget {
  final String childId;

  const GrowthHistoryPage({super.key, required this.childId});

  @override
  State<GrowthHistoryPage> createState() => _GrowthHistoryPageState();
}

class _GrowthHistoryPageState extends State<GrowthHistoryPage> {
  static const _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  String _sortOrder = 'Terbaru';

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')} ${_months[date.month - 1]} ${date.year}';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GrowthHistoryCubit>()..fetchHistory(widget.childId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: const HeaderBasic(
          backgroundColor: Color(0xFFF5F5F5),
          title: 'Riwayat Pertumbuhan',
        ),
        body: BlocBuilder<GrowthHistoryCubit, GrowthHistoryState>(
          builder: (context, state) {
            if (state is GrowthHistoryLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF00A735)),
              );
            }

            if (state is GrowthHistoryError) {
              return Center(child: Text(state.message));
            }

            if (state is GrowthHistoryLoaded) {
              final sortedHistory = _sortOrder == 'Terbaru'
                  ? state.history.toList()
                  : state.history.reversed.toList();

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    // Dropdown Urutkan (UI Only)
                    GestureDetector(
                      onTap: _showSortPicker,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _sortOrder == 'Terbaru' ? 'Urutkan' : 'Terlama',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 16.sp,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: ListView.separated(
                        itemCount: sortedHistory.length,
                        separatorBuilder: (_, _) => SizedBox(height: 16.h),
                        itemBuilder: (_, index) => HistoryRecordCard(
                          record: sortedHistory[index],
                          formatDate: _formatDate,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showSortPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 24.h),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Urutkan',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Terbaru',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _sortOrder = 'Terbaru';
                  });
                  context.pop();
                },
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Terlama',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _sortOrder = 'Terlama';
                  });
                  context.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
