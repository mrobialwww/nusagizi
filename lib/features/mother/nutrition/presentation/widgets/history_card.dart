import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_history_record_entity.dart';
import 'package:nusagizi/core/utils/number_extension.dart';
import 'package:nusagizi/core/widgets/status_badge.dart';
import 'package:nusagizi/router.dart';

class HistoryCard extends StatelessWidget {
  final NutritionHistoryRecordEntity data;
  final String childId;
  final String reportId;

  const HistoryCard({
    super.key,
    required this.data,
    required this.childId,
    required this.reportId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header Row (Date)
        Text(
          data.dateStr,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        // Content Card
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
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
              // Top Section (Asupan)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F5E9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.directions_walk,
                          color: Color(0xFF4CAF50),
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.intakeLabel,
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            data.intakeSubLabel,
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 12.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  StatusBadge(status: data.status),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Divider(height: 1, color: Color(0xFFEEEEEE)),
              ),
              // Bottom Section (Kalori & Protein)
              Row(
                children: [
                  _buildNutrientStat(
                    Icons.local_fire_department,
                    const Color(0xFFF44336),
                    const Color(0xFFFFEBEE),
                    "Kalori",
                    data.totalKcal.toMacroFormat(),
                    "kcal",
                  ),
                  _buildNutrientStat(
                    Icons.kebab_dining,
                    const Color(0xFFFF9800),
                    const Color(0xFFFFF3E0),
                    "Protein",
                    data.totalProtein.toMacroFormat(),
                    "g",
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  _buildNutrientStat(
                    Icons.water_drop,
                    const Color(0xFF4CAF50),
                    const Color(0xFFE8F5E9),
                    "Lemak",
                    data.totalFat.toMacroFormat(),
                    "g",
                  ),
                  _buildNutrientStat(
                    Icons.grain,
                    const Color(0xFF2196F3),
                    const Color(0xFFE3F2FD),
                    "Karbohidrat",
                    data.totalCarbs.toMacroFormat(),
                    "g",
                  ),
                ],
              ),

              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.pushNamed(
                      AppRoutes.nutritionHistoryMenu.name,
                      extra: {
                        'childId': childId,
                        'reportId': reportId,
                        'dateStr': data.dateStr,
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF00A735)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    "Lihat Resep",
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: const Color(0xFF00A735),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientStat(
    IconData icon,
    Color iconColor,
    Color bgColor,
    String label,
    String value,
    String unit,
  ) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (unit.isNotEmpty) ...[
                    SizedBox(width: 4.w),
                    Text(
                      unit,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
