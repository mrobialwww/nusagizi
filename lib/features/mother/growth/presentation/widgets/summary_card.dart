import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/widgets/app_card.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/latest_growth_report_cubit.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/latest_growth_report_state.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/latest_growth_report_entity.dart';
import 'package:nusagizi/core/widgets/status_badge.dart';

String _monthName(int m) => const [
  '',
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
][m];

class SummaryCard extends StatelessWidget {
  final Color accentColor;

  const SummaryCard({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LatestGrowthReportCubit, LatestGrowthReportState>(
      builder: (context, state) {
        if (state is LatestGrowthReportLoading) {
          return _buildSkeleton();
        } else if (state is LatestGrowthReportError) {
          return AppCard(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  state.message,
                  style: GoogleFonts.outfit(color: Colors.red, fontSize: 13.sp),
                ),
              ),
            ),
          );
        } else if (state is LatestGrowthReportSuccess) {
          return _buildContent(state.data);
        }

        return AppCard(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Text(
                'Data belum tersedia.',
                style: GoogleFonts.outfit(
                  color: Colors.black54,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(LatestGrowthReportEntity report) {
    final d = report.measuredAt;
    int year = d.year;
    if (year < 100) year += 2000; // Handle 2-digit years parsed incorrectly

    final dateStr =
        '${d.day.toString().padLeft(2, '0')} ${_monthName(d.month)} $year';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ringkasan Tumbuh',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                  color: Colors.black87,
                ),
              ),
              StatusBadge(status: report.status),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Terakhir diperbarui: $dateStr',
            style: GoogleFonts.outfit(fontSize: 11.sp, color: Colors.black45),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _measureItem(
                  Icons.monitor_weight_rounded,
                  'Berat',
                  report.weightKg != null ? '${report.weightKg}' : '-',
                  'kg',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _measureItem(
                  Icons.straighten_rounded,
                  'Tinggi',
                  report.heightCm != null ? '${report.heightCm?.toInt()}' : '-',
                  'cm',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _measureItem(
                  Icons.face_rounded,
                  'L.Kepala',
                  report.headCircumferenceCm != null
                      ? '${report.headCircumferenceCm?.toInt()}'
                      : '-',
                  'cm',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _measureItem(IconData icon, String label, String value, String unit) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA), // Light grey background
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.sp, color: Colors.black54),
              SizedBox(width: 4.w),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 22.sp,
                  color: Colors.black87,
                ),
              ),
              if (value != '-') ...[
                SizedBox(width: 4.w),
                Text(
                  unit,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildSkeleton() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120.w,
                height: 24.h,
                color: Colors.grey.shade200,
              ),
              Container(
                width: 70.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Container(width: 150.w, height: 16.h, color: Colors.grey.shade200),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 46.h,
                  color: Colors.grey.shade200,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 46.h,
                  color: Colors.grey.shade200,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 46.h,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
