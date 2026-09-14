import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_summary_entity.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/widgets/status_badge.dart';

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
  final Set<int> _checkedFocuses = {};

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
        // Gunakan SingleChildScrollView agar tidak overflow
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Ringkasan ${widget.childData.name}',
                      style: GoogleFonts.outfit(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
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

              // Tumbuh & Kembang row - pakai IntrinsicHeight agar tinggi sama
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tumbuh
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.goNamed(
                          AppRoutes.growth.name,
                          extra: widget.childData.id,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F6F4),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Tumbuh',
                                style: GoogleFonts.outfit(
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
                                        style: GoogleFonts.outfit(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'kg',
                                            style: GoogleFonts.outfit(
                                              color: Colors.black,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.normal,
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
                                  Icon(
                                    Icons.straighten,
                                    size: 18.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            '${widget.childData.heightCm.toStringAsFixed(0)} ',
                                        style: GoogleFonts.outfit(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'cm',
                                            style: GoogleFonts.outfit(
                                              color: Colors.black,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.normal,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Kembang
                    Expanded(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Kembang',
                                style: GoogleFonts.outfit(
                                  color: Colors.grey[700],
                                  fontSize: 14.sp,
                                ),
                              ),
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
                                      style: GoogleFonts.outfit(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // Gizi
              GestureDetector(
                onTap: () => context.goNamed(
                  AppRoutes.nutrition.name,
                  extra: widget.childData.id,
                ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Gizi',
                              style: GoogleFonts.outfit(
                                color: Colors.grey[700],
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: StatusBadge(
                              status: widget.childData.nutritionStatus,
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
                            style: GoogleFonts.outfit(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                text: '${widget.childData.proteinCurrent}g ',
                                style: GoogleFonts.outfit(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '/ ${widget.childData.proteinTarget}g',
                                    style: GoogleFonts.outfit(
                                      color: Colors.grey,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal,
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
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Fokus Hari Ini
              GestureDetector(
                onTap:
                    () {}, // Mencegah event tap merambat ke parent (flip card)
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
                        style: GoogleFonts.outfit(
                          color: Colors.grey[700],
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ...List.generate(widget.childData.dailyFocuses.length, (
                        index,
                      ) {
                        final focusText = widget.childData.dailyFocuses[index];
                        final isChecked = _checkedFocuses.contains(index);
                        return _buildCheckboxItem(focusText, isChecked, () {
                          setState(() {
                            if (isChecked) {
                              _checkedFocuses.remove(index);
                            } else {
                              _checkedFocuses.add(index);
                            }
                          });
                        });
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                style: GoogleFonts.outfit(
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
