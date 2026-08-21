import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_history_cubit.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_history_state.dart';
import 'package:nusagizi/core/widgets/status_badge.dart';

class GrowthHistoryPage extends StatefulWidget {
  final String childId;

  const GrowthHistoryPage({super.key, required this.childId});

  @override
  State<GrowthHistoryPage> createState() => _GrowthHistoryPageState();
}

class _GrowthHistoryPageState extends State<GrowthHistoryPage> {
  String _sortOrder = 'Terbaru';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GrowthHistoryCubit>()..fetchHistory(widget.childId),
      child: BlocBuilder<GrowthHistoryCubit, GrowthHistoryState>(
        builder: (context, state) {
          if (state is GrowthHistoryLoading) {
            return const Scaffold(
              backgroundColor: Color(0xFFF5F5F5),
              appBar: HeaderBasic(
                backgroundColor: Color(0xFFF5F5F5),
                title: 'Riwayat Pertumbuhan',
              ),
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF00A735)),
              ),
            );
          } else if (state is GrowthHistoryError) {
            return Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              appBar: const HeaderBasic(
                backgroundColor: Color(0xFFF5F5F5),
                title: 'Riwayat Pertumbuhan',
              ),
              body: Center(child: Text(state.message)),
            );
          } else if (state is GrowthHistoryLoaded) {
            final history = state.history;
            final sortedHistory = _sortOrder == 'Terbaru'
                ? history.toList()
                : history.reversed.toList();

            String formatDate(DateTime date) {
              const months = [
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
              return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
            }

            return Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              appBar: const HeaderBasic(
                backgroundColor: Color(0xFFF5F5F5),
                title: 'Riwayat Pertumbuhan',
              ),
              body: Padding(
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
                              style: GoogleFonts.outfit(
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
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final record = sortedHistory[index];
                          final isWarning =
                              record.status.toLowerCase() != 'normal';

                          return Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatDate(record.measuredAt),
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    StatusBadge(status: record.status),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    _buildInfoBox(
                                      'Berat',
                                      '${record.weightKg ?? "-"}',
                                      'kg',
                                      Icons.monitor_weight_outlined,
                                    ),
                                    SizedBox(width: 8.w),
                                    _buildInfoBox(
                                      'Tinggi',
                                      '${record.heightCm?.toInt() ?? "-"}',
                                      'cm',
                                      Icons.height,
                                    ),
                                    SizedBox(width: 8.w),
                                    _buildInfoBox(
                                      'L.Kepala',
                                      '${record.headCircumferenceCm?.toInt() ?? "-"}',
                                      'cm',
                                      Icons.face_outlined,
                                    ),
                                  ],
                                ),
                                if (isWarning) ...[
                                  SizedBox(height: 16.h),
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFEAEA),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Text(
                                            record.description,
                                            style: GoogleFonts.outfit(
                                              fontSize: 11.sp,
                                              color: Colors.red,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoBox(String title, String value, String unit, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 12.sp, color: Colors.black54),
                SizedBox(width: 4.w),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: GoogleFonts.outfit(
                      fontSize: 10.sp,
                      color: Colors.black87,
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
                  style: GoogleFonts.outfit(
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
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _sortOrder = 'Terbaru';
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Terlama',
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _sortOrder = 'Terlama';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
