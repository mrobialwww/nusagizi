import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/router.dart';

import 'package:nusagizi/features/mother/growth/presentation/cubit/latest_growth_report_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewDataBottomSheets extends StatelessWidget {
  final Color accentColor;
  final String childId;
  const AddNewDataBottomSheets({super.key, required this.accentColor, required this.childId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await context.pushNamed(AppRoutes.growthAdd.name, extra: childId);
            if (result == true && context.mounted) {
              context.read<LatestGrowthReportCubit>().fetchLatestGrowthReport(childId);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
            elevation: 0,
          ),
          icon: Icon(Icons.add, size: 20.sp),
          label: Text(
            'Data Pertumbuhan Baru',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
            ),
          ),
        ),
      ),
    );
  }
}
