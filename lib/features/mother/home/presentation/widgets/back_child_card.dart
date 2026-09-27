import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_summary_entity.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/widgets/status_badge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/daily_focus_cubit.dart';

class BackChildCard extends StatefulWidget {
  final ChildSummaryEntity childData;
  final VoidCallback onFlip;

  const BackChildCard({
    super.key,
    required this.childData,
    required this.onFlip,
  });

  @override
  State<BackChildCard> createState() => _BackChildCardState();
}

class _BackChildCardState extends State<BackChildCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onFlip,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FDF9),
          borderRadius: BorderRadius.circular(32.r),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Ringkasan ${widget.childData.name}',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onFlip,
                    child: Icon(Icons.replay, color: Colors.black, size: 28.sp),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildGrowthCard(context),
                    SizedBox(width: 12.w),
                    _buildDevelopmentCard(context),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              _buildNutritionCard(context),
              SizedBox(height: 12.h),
              _buildDailyFocusCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrowthCard(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            context.goNamed(AppRoutes.growth.name, extra: widget.childData.id),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F4),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tumbuh',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.monitor_weight_outlined,
                      size: 18.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text:
                              '${widget.childData.weightKg.toStringAsFixed(1).replaceAll('.', ',')} ',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                          children: [
                            TextSpan(
                              text: 'kg',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.straighten, size: 18.sp, color: Colors.grey),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text:
                              '${widget.childData.heightCm.toStringAsFixed(0)} ',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                          children: [
                            TextSpan(
                              text: 'cm',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                StatusBadge(
                  status: widget.childData.growthStatus,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDevelopmentCard(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.goNamed(
          AppRoutes.development.name,
          extra: widget.childData.id,
        ),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F4),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Kembang',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    fontSize: 14.sp,
                  ),
                ),
                // Empty state if max score is 0
                if (widget.childData.developmentMaxScore == 0) ...[
                  SizedBox(height: 12.h),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Yuk mulai\nasesmen',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            fontSize: 13.sp,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Mulai asesmen',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                                fontSize: 11.sp,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                ] else ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.assignment_turned_in_outlined,
                        size: 18.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          '${widget.childData.developmentScore}/${widget.childData.developmentMaxScore}',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  StatusBadge(
                    status: widget.childData.developmentStatus,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionCard(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.goNamed(AppRoutes.nutrition.name, extra: widget.childData.id),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6F4),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.childData.proteinTarget == 0) ...[
              SizedBox(height: 18.h),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Yuk mulai penuhi gizi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lihat resep hari ini',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                            fontSize: 12.sp,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 16.sp,
                          color: Colors.grey[700],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Gizi',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: StatusBadge(
                      status: widget.childData.nutritionStatus,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Protein',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        text: '${widget.childData.proteinCurrent}g ',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                        children: [
                          TextSpan(
                            text: '/ ${widget.childData.proteinTarget}g',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: widget.childData.proteinTarget > 0
                      ? (widget.childData.proteinCurrent /
                                widget.childData.proteinTarget)
                            .clamp(0.0, 1.0)
                      : 0,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.orange,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDailyFocusCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6F4),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Fokus Hari Ini',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 10.h),
            BlocBuilder<DailyFocusCubit, Map<String, List<int>>>(
              bloc: sl<DailyFocusCubit>(),
              builder: (context, state) {
                final focusOptions = [
                  'Berikan makan siang sesuai rekomendasi',
                  'Upload foto makan siang',
                  'Apakah sudah membeli semua bahan masakan?',
                ];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(focusOptions.length, (index) {
                    final focusText = focusOptions[index];
                    final isChecked = sl<DailyFocusCubit>().isChecked(
                      widget.childData.id,
                      index,
                    );
                    return _buildCheckboxItem(focusText, isChecked, () {
                      sl<DailyFocusCubit>().toggleFocus(
                        widget.childData.id,
                        index,
                      );
                    });
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxItem(String text, bool isChecked, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22,
              height: 22,
              margin: EdgeInsets.only(top: 2.h, right: 10.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isChecked
                      ? const Color(0xFF00A735)
                      : Colors.grey[400]!,
                  width: isChecked ? 0 : 1.5,
                ),
                borderRadius: BorderRadius.circular(6.r),
                color: isChecked ? const Color(0xFF00A735) : Colors.white,
              ),
              child: isChecked
                  ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                  : null,
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
