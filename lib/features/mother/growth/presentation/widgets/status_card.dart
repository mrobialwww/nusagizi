import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/widgets/app_card.dart';
import 'package:nusagizi/core/widgets/status_badge.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_analyses_cubit.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_analyses_state.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrowthAnalysesCubit, GrowthAnalysesState>(
      builder: (context, state) {
        String title = 'Menganalisis...';
        String desc = 'Sedang mengevaluasi data pertumbuhan...';

        if (state is GrowthAnalysesLoaded) {
          if (state.data.messageTitle != null &&
              state.data.messageDescription != null) {
            title = state.data.messageTitle!;
            desc = state.data.messageDescription!;
          } else {
            title = 'Data belum tersedia';
            desc =
                'Deskripsi analisis akan muncul setelah pengukuran dilakukan.';
          }
        } else if (state is GrowthAnalysesError) {
          title = 'Gagal Memuat';
          desc = state.message;
        }

        final statusColor = StatusBadge.getColorForStatus(title);

        return AppCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.circle, size: 10.sp, color: statusColor),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: statusColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      desc,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
