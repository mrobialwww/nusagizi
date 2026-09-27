import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_history_record_entity.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/nutrition_history_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/nutrition_history_state.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/history_card.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nusagizi/core/config/assets/app_vectors.dart';

class NutritionHistoryPage extends StatefulWidget {
  final ChildHeaderEntity? child;
  const NutritionHistoryPage({super.key, this.child});

  @override
  State<NutritionHistoryPage> createState() => _NutritionHistoryPageState();
}

class _NutritionHistoryPageState extends State<NutritionHistoryPage> {
  int _currentMonthIndex = 0;
  late List<String> _months;

  late NutritionHistoryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<NutritionHistoryCubit>();
    _months = _generateMonthsFromAge(widget.child?.age);
    _fetchDataForCurrentMonth();
  }

  void _fetchDataForCurrentMonth() {
    if (widget.child == null) return;

    final currentStr = _months[_currentMonthIndex];
    final parts = currentStr.split(' ');
    if (parts.length == 2) {
      final monthName = parts[0];
      final year = int.tryParse(parts[1]) ?? DateTime.now().year;

      const monthNames = [
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
      final monthIdx = monthNames.indexOf(monthName) + 1;

      if (monthIdx > 0) {
        _cubit.fetchReports(widget.child!.id, monthIdx, year);
      }
    }
  }

  List<String> _generateMonthsFromAge(String? ageStr) {
    final now = DateTime.now();
    const monthNames = [
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

    int totalMonths = 0;

    if (ageStr != null && ageStr.isNotEmpty) {
      final yearMatch = RegExp(
        r'(\d+)\s*Tahun',
        caseSensitive: false,
      ).firstMatch(ageStr);
      final monthMatch = RegExp(
        r'(\d+)\s*Bulan',
        caseSensitive: false,
      ).firstMatch(ageStr);

      if (yearMatch != null) {
        totalMonths += int.parse(yearMatch.group(1)!) * 12;
      }
      if (monthMatch != null) {
        totalMonths += int.parse(monthMatch.group(1)!);
      }
    }

    List<String> result = [];

    for (int i = 0; i <= totalMonths; i++) {
      int year = now.year;
      int month = now.month - i;

      while (month <= 0) {
        month += 12;
        year -= 1;
      }

      String monthName = monthNames[month - 1];
      result.add('$monthName $year');
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: HeaderBasic(
          backgroundColor: const Color(0xFFF7F7F7),
          title: "Riwayat Gizi",
          actions: [
            Container(
              margin: EdgeInsets.only(right: 24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.file_download_outlined,
                  color: Colors.black87,
                  size: 20.sp,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<NutritionHistoryCubit, NutritionHistoryState>(
              builder: (context, state) {
                final avgCalories =
                    state is NutritionHistoryLoaded && state.reports.isNotEmpty
                    ? state.reports
                              .map((r) => r.calories)
                              .reduce((a, b) => a + b) /
                          state.reports.length
                    : 0.0;
                return _buildMonthSelector(avgCalories);
              },
            ),
            Expanded(
              child: BlocBuilder<NutritionHistoryCubit, NutritionHistoryState>(
                builder: (context, state) {
                  if (state is NutritionHistoryLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00A735),
                      ),
                    );
                  } else if (state is NutritionHistoryError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  } else if (state is NutritionHistoryLoaded) {
                    final reports = state.reports;
                    if (reports.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 8.h,
                      ),
                      itemCount: reports.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 24.h),
                      itemBuilder: (context, index) {
                        final report = reports[index];

                        // Mapping Meal Times
                        int makanCount = 0;
                        int snackCount = 0;
                        for (final meal in report.mealTimes) {
                          if (['breakfast', 'lunch', 'dinner'].contains(meal)) {
                            makanCount++;
                          } else if ([
                            'morning_snack',
                            'afternoon_snack',
                          ].contains(meal)) {
                            snackCount++;
                          }
                        }

                        String intakeSubLabel = "Porsi dihabiskan";
                        if (makanCount > 0 && snackCount > 0) {
                          intakeSubLabel =
                              "$makanCount Makan, $snackCount Snack";
                        } else if (makanCount > 0) {
                          intakeSubLabel = "$makanCount Makan";
                        } else if (snackCount > 0) {
                          intakeSubLabel = "$snackCount Snack";
                        }

                        final record = NutritionHistoryRecordEntity(
                          dateStr: DateFormat(
                            'dd MMM yyyy',
                            'id_ID',
                          ).format(report.createdAt),
                          status: report.status,
                          intakeLabel: "Total Asupan",
                          intakeSubLabel: intakeSubLabel,
                          totalKcal: report.calories,
                          totalProtein: report.protein,
                          totalFat: report.fat,
                          totalCarbs: report.carbohydrate,
                        );

                        return HistoryCard(
                          data: record,
                          childId: widget.child!.id,
                          reportId: report.id,
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector(double avgCalories) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _currentMonthIndex < _months.length - 1
                  ? () {
                      setState(() => _currentMonthIndex++);
                      _fetchDataForCurrentMonth();
                    }
                  : null,
              child: Icon(
                Icons.chevron_left,
                color: _currentMonthIndex < _months.length - 1
                    ? Colors.black54
                    : Colors.grey[300],
              ),
            ),
            Column(
              children: [
                Text(
                  _months[_currentMonthIndex],
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Rata-rata: ${avgCalories.toStringAsFixed(0)} kcal/hari",
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: _currentMonthIndex > 0
                  ? () {
                      setState(() => _currentMonthIndex--);
                      _fetchDataForCurrentMonth();
                    }
                  : null,
              child: Icon(
                Icons.chevron_right,
                color: _currentMonthIndex > 0
                    ? Colors.black54
                    : Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppVectors.emptySearch, height: 250.h),
                SizedBox(height: 24.h),
                Text(
                  "Belum Ada Riwayat Gizi",
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Semua analisis nutrisi dan data makanan yang diberikan ke si kecil tersimpan rapi di halaman ini.",
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
          ),
        ],
      ),
    );
  }
}
